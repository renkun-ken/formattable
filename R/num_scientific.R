#' Numeric vector with scientific format
#'
#' Formats numbers in scientific format.
#'
#' @family numeric vectors
#' @param x a numeric vector.
#' @param format format type passed to [formatC()].
#' @param ... additional parameter passed to `formattable`.
#' @export
#' @examples
#' num_scientific(1250000)
#' num_scientific(1253421, digits = 8)
#' num_scientific(1253421, digits = 8, format = "E")
num_scientific <- function(x, format = c("e", "E"), ...) {
  formattable(as_numeric(x), format = match.arg(format), ...)
}
