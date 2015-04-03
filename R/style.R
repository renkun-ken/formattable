#' @export
style <- function(...) {
  as.character(.mapply(function(...) {
    args <- list(...)
    paste(names(args), args, sep = ": ", collapse = "; ")
  }, list(...), NULL))
}
