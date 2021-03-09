accounting_postproc <- function(str, x) {
  sprintf(
    ifelse(is.na(x) | x >= 0, "%s", "(%s)"),
    gsub("-", "", str, fixed = TRUE)
  )
}

#' Numeric vector with accounting format
#' @inheritParams comma
#' @export
accounting <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  UseMethod("accounting")
}

#' @rdname accounting
#' @export
#' @examples
#' accounting(15320)
#' accounting(-12500)
#' accounting(c(1200, -3500, 2600), format = "d")
accounting.default <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(as_numeric(x),
    format = format, big.mark = big.mark, digits = digits, ...,
    postproc = "accounting_postproc"
  )
}

#' @rdname accounting
#' @export
#' @examples
#' accounting(c("123,23.50", "(123.243)"))
accounting.character <- function(x, digits = max(get_digits(x)),
                                 format = "f", big.mark = ",", ...) {
  sgn <- ifelse(grepl("\\(.+\\)", x), -1, 1)
  num <- gsub("\\((.+)\\)", "\\1", gsub(big.mark, "", x, fixed = TRUE))
  copy_dim(x, accounting.default(sgn * as.numeric(num),
    digits = digits,
    format = format, big.mark = big.mark, ...
  ))
}
