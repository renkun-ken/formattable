#' Percentage representation of numeric values
#'
#' @param x a numeric vector.
#' @param digits an integer to indicate the number of digits of the percentage string.
#' @param format format type passed to \code{\link{formatC}}.
#' @param ... Additional parameters passed to \code{formatC}.
#' @export
#' @examples
#' percent(rnorm(10, 0, 0.1))
#' percent(rnorm(10, 0, 0.1), digits = 0)
percent <- function(x)
  UseMethod("percent")

#' @export
percent.default <- function(x) {
  percent.numeric(as.numeric(x))
}

#' @export
percent.numeric <- function(x) {
  if ("percent" %in% (class <- class(x)))
    return(x)
  class(x) <- c("percent", class)
  x
}

#' @export
as.character.percent <- function(x, digits = 2L, format = "f",
  na.encode = FALSE, justify = "none", ...) {
  paste0(formatC(100 * as.numeric(x), format = format, digits = digits, ...),
    ifelse(is.na(x), "", "%"))
}

#' @export
format.percent <- function(x, ...) {
  as.character.percent(x, ...)
}

#' @export
print.percent <- function(x, ...) {
  print(as.character.percent(x), ..., quote = FALSE)
}

#' @export
c.percent <- function(x, ...) {
  percent(c(unclass(x), ...))
}
