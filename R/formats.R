#' Numeric vector with percentage format
#'
#' @param x a numeric vector.
#' @param digits an integer to indicate the number of digits of the percentage string.
#' @param format format type passed to \code{\link{formatC}}.
#' @param ... additional parameters passed to \code{formattable}.
#' @export
#' @examples
#' percent(rnorm(10, 0, 0.1))
#' percent(rnorm(10, 0, 0.1), digits = 0)
percent <- function(x, digits = 2L, format = "f", ...) {
  formattable(x, format = format, digits = digits, ...,
    preproc = function(x) x * 100,
    postproc = function(str, x) paste0(str, ifelse(is.na(x), "", "%")))
}

#' Numeric vector with thousands separators
#' @inheritParams percent
#' @param big.mark thousands separator
#' @export
comma <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(x, format = format, big.mark = big.mark, digits = 2L, ...)
}

#' Numeric vector with currency format
#' @inheritParams comma
#' @param symbol currency symbol
#' @export
currency <- function(x, symbol = "$", digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(x, format = format, big.mark = big.mark, digits = digits, ...,
    postproc = function(str, x) sprintf("%s%s", symbol, str))
}

#' Numeric vector with accounting format
#' @inheritParams comma
#' @export
accounting <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(x, format = format, big.mark = big.mark, digits = digits, ...,
    postproc = function(str, x)
      sprintf(ifelse(x >= 0, "%s", "(%s)"), gsub("-", "", str, fixed = TRUE)))
}

#' Numeric vector with scientific format
#' @param format format type passed to \code{\link{formatC}}.
#' @param ... additional parameter passed to \code{formattable}.
#' @export
scientific <- function(x, format = "e", ...) {
  formattable(x, format = format, ...)
}

#' Date/time vector with formatting
#' @param format format type passed to \code{\link{format}}.
#' @param ... additional parameter passed to \code{formattable}.
#' @export
datetime <- function(x, format = "", ...) {
  formattable(x, format = format, ...)
}
