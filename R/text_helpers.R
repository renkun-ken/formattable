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
percent <- function(x, digits = 2L, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}

