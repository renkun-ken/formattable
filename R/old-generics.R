#' Legacy generics
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' These generics are soft-deprecated.
#' New code should use the `num_...()` or `parse_...()` functions instead,
#' such as [num_accounting()].
#' @inheritParams num_accounting
#' @name legacy
#' @keywords internal
#' @export
accounting <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
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
  UseMethod("currency")
}
#' @export
currency.default <- num_currency
#' @export
currency.character <- parse_currency
