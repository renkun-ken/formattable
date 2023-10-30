check_installed <- function(...) {
  packages <- c(...)

  for (pkg in packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      msg <- paste0("Please install the ", pkg, " package.")
      if (identical(Sys.getenv("TESTTHAT"), "true")) {
        testthat::skip(msg)
      } else {
        stop(msg, call. = FALSE)
      }
    }
  }
}
