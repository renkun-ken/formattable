# Prove the dependency world installs before any shard spends a minute on
# checks: install the union of every dependency any revdep needs into a
# scratch library -- which downloads every binary exactly once into the pak
# cache the workflow then saves for the shards -- and load-test each installed
# package. Broken or uninstallable dependencies surface here, in depfail.json
# and the job summary.
#
# A dependency failure is a report, not a stop: shards attempt their own
# subset regardless (their repository snapshot may succeed where this one
# failed), and a revdep whose dependencies genuinely cannot be installed fails
# its own check with an install log, which is the result a report can work
# with.
#
# Environment variables:
#   PLAN     - plan.json from plan.R (default: plan.json)
#   OUT_DIR  - where depfail.json lands (default: preflight)

source(file.path(dirname(sub("--file=", "", grep("^--file=", commandArgs(), value = TRUE))), "util.R"))

plan <- read_json(env_chr("PLAN", "plan.json"))
out_dir <- env_chr("OUT_DIR", "preflight")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
install_union <- unlist(plan$install_union, use.names = FALSE)

lib <- file.path(env_chr("RUNNER_TEMP", tempdir()), "revdep2-preflight-lib")
dir.create(lib, recursive = TRUE, showWarnings = FALSE)
failures <- list()

inform("Preflight: installing ", length(install_union), " packages")
installed_ok <- tryCatch(
  {
    pak::pkg_install(install_union, lib = lib, ask = FALSE)
    TRUE
  },
  error = function(e) {
    inform("Bulk install failed: ", conditionMessage(e))
    FALSE
  }
)
if (!installed_ok) {
  # One bad package must not hide the state of the other thousand: retry each
  # missing package on its own and record exactly which ones will not install.
  for (p in install_union) {
    if (dir.exists(file.path(lib, p))) {
      next
    }
    result <- tryCatch(
      {
        pak::pkg_install(p, lib = lib, ask = FALSE)
        NULL
      },
      error = function(e) conditionMessage(e)
    )
    if (!is.null(result)) {
      failures[[length(failures) + 1]] <- list(
        package = p,
        phase = "install",
        message = result
      )
    }
  }
}

# Load every installed dependency, in chunks small enough to stay clear of the
# DLL limit; a failing chunk is retried one package at a time so a single bad
# namespace names itself.
installed <- intersect(install_union, rownames(utils::installed.packages(lib)))
inform("Preflight: loading ", length(installed), " packages")
load_batch <- function(pkgs) {
  script <- tempfile(fileext = ".R")
  writeLines(
    c(
      sprintf(".libPaths(c(%s, .libPaths()))", deparse(lib)),
      "for (p in commandArgs(trailingOnly = TRUE)) {",
      "  loadNamespace(p)",
      "  writeLines(paste0('LOADED ', p))",
      "}"
    ),
    script
  )
  out <- suppressWarnings(system2(
    "Rscript",
    c("--vanilla", script, pkgs),
    stdout = TRUE,
    stderr = TRUE
  ))
  loaded <- sub("^LOADED ", "", grep("^LOADED ", out, value = TRUE))
  list(failed = setdiff(pkgs, loaded), log = out)
}
chunks <- split(installed, ceiling(seq_along(installed) / 40))
for (chunk in chunks) {
  first <- load_batch(chunk)
  if (length(first$failed) == 0) {
    next
  }
  for (p in first$failed) {
    single <- load_batch(p)
    if (length(single$failed) > 0) {
      failures[[length(failures) + 1]] <- list(
        package = p,
        phase = "load",
        message = paste(utils::tail(sanitize_log(single$log), 20), collapse = "\n")
      )
    }
  }
}

write_json(failures, file.path(out_dir, "depfail.json"))

append_summary(c(
  "## revdep2 preflight",
  "",
  sprintf(
    "Installed and loaded %d dependencies: %d could not be installed or loaded.",
    length(install_union), length(failures)
  ),
  ""
))
if (length(failures) > 0) {
  df <- data.frame(
    Package = vapply(failures, function(f) f$package, character(1)),
    Phase = vapply(failures, function(f) f$phase, character(1))
  )
  append_summary(md_table(df))
  for (f in failures) {
    append_summary(md_details(
      sprintf("<code>%s</code> &mdash; %s failure", f$package, f$phase),
      strsplit(f$message, "\n")[[1]]
    ))
  }
  inform(length(failures), " dependencies failed preflight; see depfail.json")
}
