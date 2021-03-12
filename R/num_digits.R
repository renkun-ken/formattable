#' Numeric vector showing pre-specific digits
#'
#' Formats numbers with
#' a prespecified number of digits after the decimal point.
#'
#' @family numeric vectors
#' @param x a numeric vector
#' @param digits an integer to indicate the number of digits to show.
#' @param format format type passed to [formatC()].
#' @param ... additional parameters passed to [formattable()].
#' @export
#' @examples
#' num_digits(pi, 2)
#' num_digits(123.45678, 3)
num_digits <- function(x, digits, format = "f", ...) {
  formattable(as.numeric(x), format = format, digits = digits, ...)
}
