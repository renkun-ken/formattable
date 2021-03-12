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