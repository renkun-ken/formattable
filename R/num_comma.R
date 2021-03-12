#' Numeric vector with thousands separators
#'
#' Formats numbers with a thousand separator
#' and a prespecified number of digits after the decimal point.
#'
#' @family numeric vectors
#' @inheritParams num_percent
#' @param big.mark thousands separator
#' @export
#' @examples
#' num_comma(1000000)
#' num_comma(c(1250000, 225000))
#' num_comma(c(1250000, 225000), format = "d")
num_comma <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(as_numeric(x), format = format, big.mark = big.mark, digits = digits, ...)
}

#' @rdname num_comma
#' @export
#' @examples
#' parse_comma("123,345.123")
parse_comma <- function(x, digits = max(get_digits(x)),
                        format = "f", big.mark = ",", ...) {
  copy_dim(x, comma.default(as.numeric(gsub(big.mark, "", x, fixed = TRUE)),
    digits = digits, format = format, big.mark = big.mark, ...
  ))
}
