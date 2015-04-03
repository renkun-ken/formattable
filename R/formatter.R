#' @export
formatter <- function(tag, ...) {
  args <- list(...)
  function(x) {
    values <- lapply(args, function(arg) {
      if(is.function(arg)) arg(x) else arg
    })
    tags <- .mapply(function(...) {
      attrs <- list(...)
      htmltools::tag(tag, attrs[!is.na(attrs)])
    }, values, NULL)
    vapply(tags, as.character, character(1L))
  }
}
