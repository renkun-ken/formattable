#' Numeric vector showing pre-specific digits
#'
#' @param x a numeric vector
#' @param digits an integer to indicate the number of digits to show.
#' @param format format type passed to [formatC()].
#' @param ... additional parameters passed to `formattable`.
#' @export
#' @examples
#' digits(pi, 2)
#' digits(123.45678, 3)
digits <- function(x, digits, format = "f", ...) {
  formattable(as.numeric(x), format = format, digits = digits, ...)
}
