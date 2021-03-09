#' Numeric vector with thousands separators
#' @inheritParams percent
#' @param big.mark thousands separator
#' @export
comma <- function(x, digits, format = "f", big.mark = ",", ...) {
  UseMethod("comma")
}

#' @rdname comma
#' @export
#' @examples
#' comma(1000000)
#' comma(c(1250000, 225000))
#' comma(c(1250000, 225000), format = "d")
comma.default <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(as_numeric(x), format = format, big.mark = big.mark, digits = digits, ...)
}

#' @rdname comma
#' @export
#' @examples
#' comma("123,345.123")
comma.character <- function(x, digits = max(get_digits(x)),
                            format = "f", big.mark = ",", ...) {
  copy_dim(x, comma.default(as.numeric(gsub(big.mark, "", x, fixed = TRUE)),
    digits = digits, format = format, big.mark = big.mark, ...
  ))
}
