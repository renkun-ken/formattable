check_installed <- function(...) {
  packages <- c(...)

  for (pkg in packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Please install the ", pkg, " package.", call. = FALSE)
    }
  }
}
