# Check one shard of a revdep2 plan: many reverse dependencies, one job, one
# shared library.
#
# The shard installs the union of its packages' dependencies once, then walks
# its packages in two phases: every package is checked against the CRAN version
# of the package under test (or its baseline result is reused), the dev binary
# is installed over the CRAN version, and every package is checked again. The
# two rcmdcheck results are compared per package, revdepcheck-style.
#
# Failure is data here, never a job failure: a package that breaks, times out,
# or cannot even install its dependencies gets a manifest entry saying so, and
# the walk continues. The job goes red only when the driver itself is broken.
#
# The shard stops starting new checks when its deadline says the next one will
# not finish, and records the rest as deferred; a later run started with
# `retry-run` picks exactly those up. Results that exist by then -- including
# an old-version result whose new-version counterpart was cut off -- are still
# uploaded, so nothing decided is lost to the deadline.
#
# Environment variables:
#   SHARD                  - shard index from plan.json (required)
#   PLAN                   - plan file (default: plan.json)
#   PKG_DIR                - the revdep2-pkg artifact: meta.json, bin/ (required)
#   BASELINE_DIR           - the revdep2-baseline artifact of the donor run;
#                            may be missing or empty, then everything is fresh
#   OUT_DIR                - results directory, uploaded as the shard artifact
#                            (default: results)
#   TIMEOUT_FACTOR         - per-check timeout as a multiple of the package's
#                            CRAN check time (default: 1.5)
#   TIMEOUT_MIN_MINUTES    - floor for that timeout; CRAN's machines are not
#                            these runners (default: 10)
#   DEADLINE_MINUTES       - stop starting new checks past this (default: 300)

source(file.path(dirname(sub("--file=", "", grep("^--file=", commandArgs(), value = TRUE))), "util.R"))

shard_index <- as.integer(env_chr("SHARD"))
stopifnot(!is.na(shard_index))
plan <- read_json(env_chr("PLAN", "plan.json"))
pkg_dir <- env_chr("PKG_DIR", "pkg")
baseline_dir <- env_chr("BASELINE_DIR", "baseline")
out_dir <- env_chr("OUT_DIR", "results")
timeout_factor <- env_num("TIMEOUT_FACTOR", 1.5)
timeout_min_sec <- env_num("TIMEOUT_MIN_MINUTES", 10) * 60
deadline <- Sys.time() + env_num("DEADLINE_MINUTES", 300) * 60

shard <- Filter(function(s) s$index == shard_index, plan$shards)[[1]]
members <- vapply(shard$packages, function(p) p$name, character(1))
meta <- read_json(file.path(pkg_dir, "meta.json"))
package <- plan$package

dir.create(file.path(out_dir, "pkgs"), recursive = TRUE, showWarnings = FALSE)
manifest_path <- file.path(out_dir, "manifest.ndjson")
file.create(manifest_path)
work <- file.path(env_chr("RUNNER_TEMP", tempdir()), "revdep2-work")
dir.create(work, recursive = TRUE, showWarnings = FALSE)

inform(
  "Shard ", shard_index, ": ", length(members), " package(s), ",
  "estimated ~", shard$estimate_minutes, " min"
)

# The running state per package; every entry ends up as one manifest line.
state <- new.env(parent = emptyenv())
for (p in shard$packages) {
  assign(
    p$name,
    list(
      package = p$name,
      version = p$version,
      level = p$level %||% 0L,
      shard = shard_index,
      weight_minutes = p$weight_minutes,
      t_total = p$t_total %||% 0,
      dep_fingerprint = p$dep_fingerprint,
      baseline_planned = isTRUE(p$baseline),
      baseline_reused = FALSE,
      result = "deferred",
      status = "",
      status_old = "",
      status_new = "",
      new_issues = 0L,
      t_old = NA,
      t_new = NA,
      old_checked_at = NA,
      message = ""
    ),
    envir = state
  )
}
update <- function(name, ...) {
  entry <- get(name, envir = state)
  entry[names(list(...))] <- list(...)
  assign(name, entry, envir = state)
  entry
}

counts <- function(x) {
  if (!inherits(x, "rcmdcheck")) {
    return("?")
  }
  sprintf(
    "%dE %dW %dN",
    length(x$errors), length(x$warnings), length(x$notes)
  )
}

# ---------------------------------------------------------------- install ----

install <- unlist(shard$install, use.names = FALSE)
inform("Installing ", length(install), " dependencies")
bulk_ok <- tryCatch(
  {
    pak::pkg_install(install, ask = FALSE)
    TRUE
  },
  error = function(e) {
    inform("Bulk install failed: ", conditionMessage(e))
    FALSE
  }
)
if (!bulk_ok) {
  for (p in install) {
    if (requireNamespace(p, quietly = TRUE)) {
      next
    }
    tryCatch(
      pak::pkg_install(p, ask = FALSE),
      error = function(e) inform("Could not install ", p, ": ", conditionMessage(e))
    )
  }
}

installed <- rownames(utils::installed.packages())
our_version <- function() {
  tryCatch(as.character(utils::packageVersion(package)), error = function(e) NA_character_)
}
our_cran_version <- our_version()
if (!identical(our_cran_version, plan$cran_version)) {
  # The library must hold the *CRAN release* for the old phase; the resolver
  # may have kept some other version it found satisfactory.
  inform(
    "Installed version is ", our_cran_version, ", plan expected ",
    plan$cran_version, "; reinstalling from the repositories"
  )
  utils::install.packages(package)
  our_cran_version <- our_version()
  if (!identical(our_cran_version, plan$cran_version)) {
    inform(
      "Note: old checks run against ", our_cran_version,
      " (the repositories lag CRAN)"
    )
  }
}

# A package whose *strong* dependency closure is incomplete cannot produce a
# check result worth comparing; missing suggests are tolerable, the check runs
# with _R_CHECK_FORCE_SUGGESTS_=false, the way CRAN treats unavailable ones.
db <- cran_db()
strong_missing <- function(name) {
  strong <- tools::package_dependencies(name, db = db, which = "strong", recursive = TRUE)[[1]]
  setdiff(intersect(strong, rownames(db)), c(installed, base_packages()))
}
runnable <- character()
for (name in members) {
  missing <- tryCatch(strong_missing(name), error = function(e) character())
  if (length(missing) > 0) {
    update(
      name,
      result = "depfail",
      message = paste("Dependencies not installed:", paste(missing, collapse = ", "))
    )
    inform(name, ": dependencies missing (", paste(missing, collapse = ", "), ")")
  } else {
    runnable <- c(runnable, name)
  }
}

# ---------------------------------------------------------------- sources ----

src_dir <- file.path(work, "src")
dir.create(src_dir, showWarnings = FALSE)
sources <- list()
for (name in runnable) {
  tarball <- tryCatch(
    {
      hit <- utils::download.packages(
        name,
        destdir = src_dir,
        repos = cran_repo(),
        type = "source",
        quiet = TRUE
      )
      hit[1, 2]
    },
    error = function(e) NULL
  )
  if (is.null(tarball)) {
    update(name, result = "error", message = "Source tarball could not be downloaded")
    inform(name, ": source download failed")
  } else {
    sources[[name]] <- tarball
    actual <- sub(sprintf("^%s_(.*)[.]tar[.]gz$", name), "\\1", basename(tarball))
    update(name, version = actual)
  }
}
runnable <- names(sources)

# ------------------------------------------------------------------ checks ---

# Stop before a check the trailing estimate says will not finish -- but always
# attempt the first check of a phase, or a mis-budgeted shard would make no
# progress at all and a retry would repeat the mistake.
checks_started <- 0L
out_of_time <- function(entry) {
  if (checks_started == 0L) {
    return(FALSE)
  }
  budget_sec <- max(entry$weight_minutes, 1) * 60 * 1.3
  Sys.time() + budget_sec > deadline
}

run_check <- function(name, phase) {
  checks_started <<- checks_started + 1L
  check_dir <- file.path(work, "check", name, phase)
  dir.create(check_dir, recursive = TRUE, showWarnings = FALSE)
  # The timeout scales with what the check costs CRAN, floored because these
  # runners are slower than CRAN's machines and a tiny package must not be
  # killed over the difference.
  timeout_sec <- max(
    timeout_min_sec,
    timeout_factor * (get(name, envir = state)$t_total %||% 0)
  )
  started <- Sys.time()
  result <- tryCatch(
    rcmdcheck::rcmdcheck(
      sources[[name]],
      args = c("--no-manual", "--as-cran"),
      error_on = "never",
      check_dir = check_dir,
      timeout = timeout_sec
    ),
    error = function(e) e
  )
  duration <- round(as.numeric(Sys.time() - started, units = "secs"))
  attr(result, "duration") <- duration
  # A check that hits the timeout is killed, and rcmdcheck surfaces that as an
  # error rather than a result object; tell it apart from a genuine crash by
  # the clock.
  attr(result, "timed_out") <- inherits(result, "error") && duration >= timeout_sec - 1
  result
}

check_failure <- function(name, phase, result) {
  if (isTRUE(attr(result, "timed_out"))) {
    update(
      name,
      result = "failed",
      message = sprintf(
        "%s check timed out after %ds", phase, attr(result, "duration")
      )
    )
    inform(name, ": ", phase, " check timed out (", attr(result, "duration"), "s)")
  } else {
    update(name, result = "error", message = conditionMessage(result))
    inform(name, ": ", phase, " check errored: ", conditionMessage(result))
  }
}

pkg_out <- function(name) {
  dir <- file.path(out_dir, "pkgs", name)
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  dir
}

# Phase 1: the CRAN version of the package under test is installed; reuse or
# produce every package's old-version result.
inform("Phase old: against ", package, " ", our_cran_version)
for (name in runnable) {
  entry <- get(name, envir = state)
  reused <- FALSE
  if (entry$baseline_planned) {
    rds <- file.path(baseline_dir, "old-rds", paste0(name, ".rds"))
    old <- tryCatch(readRDS(rds), error = function(e) NULL)
    if (!is.null(old)) {
      saveRDS(old, file.path(pkg_out(name), "old.rds"))
      donor <- Filter(
        function(e) identical(e$package, name),
        read_json(file.path(baseline_dir, "baseline.json"))
      )
      update(
        name,
        baseline_reused = TRUE,
        status_old = counts(old),
        old_checked_at = if (length(donor) > 0) donor[[1]]$checked_at else NA
      )
      reused <- TRUE
      inform(name, ": baseline reused")
    } else {
      inform(name, ": planned baseline unavailable, checking fresh")
    }
  }
  if (!reused) {
    if (out_of_time(entry)) {
      inform(name, ": deferred (deadline)")
      next
    }
    old <- run_check(name, "old")
    if (inherits(old, "error")) {
      check_failure(name, "old", old)
      next
    }
    saveRDS(old, file.path(pkg_out(name), "old.rds"))
    update(
      name,
      status_old = counts(old),
      t_old = attr(old, "duration"),
      old_checked_at = now_utc()
    )
    inform(name, ": old ", counts(old), " (", attr(old, "duration"), "s)")
  }
}

# Between the phases: the dev binary replaces the CRAN version.
binary <- file.path(pkg_dir, meta$binary)
inform("Installing dev binary ", basename(binary))
if (system2("R", c("CMD", "INSTALL", shQuote(binary))) != 0) {
  stop("Installing the prebuilt dev binary failed", call. = FALSE)
}
our_dev_version <- as.character(utils::packageVersion(package))

# Phase 2: check against the dev version and compare.
inform("Phase new: against ", package, " ", our_dev_version)
for (name in runnable) {
  entry <- get(name, envir = state)
  if (entry$result != "deferred") {
    next # depfail or error already decided
  }
  if (!file.exists(file.path(pkg_out(name), "old.rds"))) {
    next # old phase never reached it; stays deferred
  }
  if (out_of_time(entry)) {
    inform(name, ": deferred (deadline)")
    next
  }
  new <- run_check(name, "new")
  if (inherits(new, "error")) {
    check_failure(name, "new", new)
    next
  }
  saveRDS(new, file.path(pkg_out(name), "new.rds"))
  old <- readRDS(file.path(pkg_out(name), "old.rds"))

  cmp <- tryCatch(
    rcmdcheck::compare_checks(old, new),
    error = function(e) NULL
  )
  if (is.null(cmp)) {
    update(name, result = "failed", status_new = counts(new), t_new = attr(new, "duration"))
  } else {
    new_issues <- sum(cmp$cmp$change == 1)
    update(
      name,
      result = classify_status(cmp$status, new_issues),
      status = cmp$status,
      status_new = counts(new),
      new_issues = new_issues,
      t_new = attr(new, "duration")
    )
  }
  entry <- get(name, envir = state)
  inform(
    name, ": ", entry$result,
    " (old ", entry$status_old, ", new ", entry$status_new,
    ", ", attr(new, "duration"), "s)"
  )

  # The parsed results carry everything the reports need; raw check output is
  # kept only where a human will want to dig, and only for the new version.
  if (entry$result == "ok") {
    unlink(file.path(work, "check", name), recursive = TRUE)
  } else {
    keep <- file.path(out_dir, "pkgs", name, "new-check")
    dir.create(keep, recursive = TRUE, showWarnings = FALSE)
    rcheck <- file.path(work, "check", name, "new", paste0(name, ".Rcheck"))
    for (f in c(
      "00check.log",
      "00install.out",
      list.files(rcheck, pattern = "[.]Rout[.]fail$", recursive = TRUE)
    )) {
      if (file.exists(file.path(rcheck, f))) {
        file.copy(file.path(rcheck, f), file.path(keep, basename(f)))
      }
    }
    unlink(file.path(work, "check", name), recursive = TRUE)
  }
}

# ---------------------------------------------------------------- manifest ---

entries <- lapply(members, function(name) get(name, envir = state))
for (entry in entries) {
  entry$our_cran_version <- our_cran_version
  entry$our_dev_version <- our_dev_version
  cat(
    jsonlite::toJSON(entry, auto_unbox = TRUE, null = "null"),
    "\n",
    sep = "",
    file = manifest_path,
    append = TRUE
  )
}

# ------------------------------------------------------------------ summary --

results <- vapply(entries, function(e) e$result, character(1))
df <- data.frame(
  Package = vapply(entries, function(e) e$package, character(1)),
  Version = vapply(entries, function(e) e$version, character(1)),
  Result = results,
  Old = vapply(entries, function(e) e$status_old, character(1)),
  New = vapply(entries, function(e) e$status_new, character(1)),
  Baseline = ifelse(
    vapply(entries, function(e) isTRUE(e$baseline_reused), logical(1)),
    "reused",
    ""
  )
)
append_summary(c(
  sprintf("### Shard %d", shard_index),
  "",
  sprintf(
    "%d ok, %d newly broken, %d failed, %d depfail, %d error, %d deferred.",
    sum(results == "ok"), sum(results == "newly_broken"), sum(results == "failed"),
    sum(results == "depfail"), sum(results == "error"), sum(results == "deferred")
  ),
  "",
  md_table(df)
))
for (entry in entries) {
  if (entry$result %in% c("ok", "deferred")) {
    next
  }
  log <- file.path(out_dir, "pkgs", entry$package, "new-check", "00check.log")
  lines <- if (nzchar(entry$message)) {
    strsplit(entry$message, "\n")[[1]]
  } else if (file.exists(log)) {
    readLines(log, warn = FALSE)
  } else {
    "(no log captured)"
  }
  append_summary(md_details(
    sprintf("<code>%s</code> &mdash; %s", entry$package, entry$result),
    lines
  ))
}

inform(
  "Shard ", shard_index, " done: ",
  paste(names(table(results)), table(results), sep = "=", collapse = ", ")
)
