#' Numeric vector with accounting format
#'
#' Formats numbers with a thousand separator
#' and two digits after the decimal point.
#'
#' @family numeric vectors
#' @inheritParams comma
#' @export
#' @examples
#' num_accounting(15320)
#' num_accounting(-12500)
#' num_accounting(c(1200, -3500, 2600), format = "d")
num_accounting <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(as_numeric(x),
    format = format, big.mark = big.mark, digits = digits, ...,
    postproc = "accounting_postproc"
  )
}

#' @rdname num_accounting
#' @export
#' @examples
#' parse_accounting(c("123,23.50", "(123.243)"))
parse_accounting <- function(x, digits = max(get_digits(x)),
                             format = "f", big.mark = ",", ...) {
  sgn <- ifelse(grepl("\\(.+\\)", x), -1, 1)
  num <- gsub("\\((.+)\\)", "\\1", gsub(big.mark, "", x, fixed = TRUE))
  copy_dim(x, accounting.default(sgn * as.numeric(num),
    digits = digits,
    format = format, big.mark = big.mark, ...
  ))
}

accounting_postproc <- function(str, x) {
  sprintf(
    ifelse(is.na(x) | x >= 0, "%s", "(%s)"),
    gsub("-", "", str, fixed = TRUE)
  )
}
