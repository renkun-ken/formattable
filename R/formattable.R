#' @export
formattable <- function(data, formatter = list(), ...)
  UseMethod("formattable")

#' @export
formattable.data.frame <- function(data, formatter = list(), align = "r", caption = NULL) {
  xdf <- data.frame(mapply(function(x, name) {
    f <- formatter[[name]]
    if(!is.null(f)) match.fun(f)(x) else x
  }, data, names(data), SIMPLIFY = FALSE), row.names = row.names(data), stringsAsFactors = FALSE)
  knitr::kable(xdf, format = "markdown", align = align, caption = caption)
}

#' @export
formattable.matrix <- function(data, formatter = list(), ...) {
  formattable.data.frame(data.frame(data, stringsAsFactors = FALSE))
}
