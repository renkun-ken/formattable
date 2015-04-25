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
percent <- function(x, format = "f", digits = 2L, ...) {
  formattable(x, format = format, digits = 2L, ...,
    preproc = function(x) x * 100,
    postproc = function(str, x) paste0(str, ifelse(is.na(x), "", "%")))
}

#' @export
decimal <- function(x, format = "f", big.mark = ",", ...) {
  formattable(x, format = "f", big.mark = big.mark, ...)
}

#' @export
currency <- function(x, symbol = "$", format = "f", big.mark = ",", digits = 2L, ...) {
  formattable(x, format = format, big.mark = big.mark, digits = digits, ...,
    postproc = function(str, x) sprintf("%s%s", symbol, str))
}

#' @export
accounting <- function(x, format = "f", big.mark = ",", digits = 2L, ...) {
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
