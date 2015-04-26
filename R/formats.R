#' Percentage representation of numeric values
#'
#' @param x a numeric vector.
#' @param format format type passed to \code{\link{formatC}}.
#' @param digits an integer to indicate the number of digits of the percentage string.
#' @param ... additional parameters passed to \code{formattable}.
#' @export
#' @examples
#' percent(rnorm(10, 0, 0.1))
#' percent(rnorm(10, 0, 0.1), digits = 0)
percent <- function(x, digits = 2L, format = "f", ...) {
  formattable(x, format = format, digits = 2L, ...,
    preproc = function(x) x * 100,
    postproc = function(str, x) paste0(str, ifelse(is.na(x), "", "%")))
}

#' @export
comma <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(x, format = format, big.mark = big.mark, digits = 2L, ...)
}

#' @export
currency <- function(x, symbol = "$", digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(x, format = format, big.mark = big.mark, digits = digits, ...,
    postproc = function(str, x) sprintf("%s%s", symbol, str))
}

#' @export
accounting <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(x, format = format, big.mark = big.mark, digits = digits, ...,
    postproc = function(str, x)
      sprintf(ifelse(x >= 0, "%s", "(%s)"), gsub("-", "", str, fixed = TRUE)))
}

#' @export
scientific <- function(x, format = "e", ...) {
  formattable(x, format = format, ...)
}

#' @export
datetime <- function(x, format = "", ...) {
  formattable(x, format = format, ...)
}
