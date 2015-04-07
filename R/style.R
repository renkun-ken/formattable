#' @export
style <- function(...) {
  dots <- list(...)
  as.character(.mapply(function(...) {
    args <- list(...)
    args <- args[!is.na(args)]
    paste(names(args), args, sep = ": ", collapse = "; ")
  }, dots, NULL))
}
