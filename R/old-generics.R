#' Legacy generics
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' These generics and functions are superseded.
#' New code should use the `num_...()` or `parse_...()` functions instead,
#' such as [num_accounting()].
#' @import lifecycle
#' @name legacy
#' @keywords internal
#' @inheritParams num_digits
#' @export
digits <- function(x, digits, format = "f", ...) {
  signal_superseded("0.3.0", "formattable::digits()", "num_digits()")
  formattable(as.numeric(x), format = format, digits = digits, ...)
}

#' @inheritParams num_scientific
#' @rdname legacy
#' @export
scientific <- function(x, format = c("e", "E"), ...) {
  signal_superseded("0.3.0", "formattable::scientific()", "num_scientific()")
  formattable(as_numeric(x), format = match.arg(format), ...)
}

#' @inheritParams num_accounting
#' @rdname legacy
#' @export
accounting <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  signal_superseded("0.3.0", "formattable::accounting()", "num_accounting()")
  UseMethod("accounting")
}
#' @export
accounting.default <- num_accounting
#' @export
accounting.character <- parse_accounting

#' @inheritParams num_comma
#' @rdname legacy
#' @export
comma <- function(x, digits, format = "f", big.mark = ",", ...) {
  signal_superseded("0.3.0", "formattable::comma()", "num_comma()")
  UseMethod("comma")
}
#' @export
comma.default <- num_comma
#' @export
comma.character <- parse_comma

#' @rdname legacy
#' @inheritParams num_currency
#' @export
currency <- function(x, symbol, digits,
                     format = "f", big.mark = ",", ...) {
  signal_superseded("0.3.0", "formattable::currency()", "num_currency()")
  UseMethod("currency")
}
#' @export
currency.default <- num_currency
#' @export
currency.character <- parse_currency

#' @rdname legacy
#' @inheritParams num_percent
#' @export
percent <- function(x, digits, format = "f", ...) {
  signal_superseded("0.3.0", "formattable::percent()", "num_percent()")
  UseMethod("percent")
}
#' @export
percent.default <- num_percent
#' @export
percent.character <- parse_percent
