accounting_postproc <- function(str, x)
  sprintf(ifelse(is.na(x) | x >= 0, "%s", "(%s)"),
    gsub("-", "", str, fixed = TRUE))

#' Numeric vector with accounting format
#' @inheritParams comma
#' @export
accounting <- function(x, digits = 2L, format = "f", big.mark = ",", ...)
  UseMethod("accounting")

#' @rdname accounting
#' @export
#' @examples
#' accounting(15320)
#' accounting(-12500)
#' accounting(c(1200, -3500, 2600), format = "d")
accounting.default <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  formattable(as_numeric(x), format = format, big.mark = big.mark, digits = digits, ...,
    postproc = "accounting_postproc")
}

#' @rdname accounting
#' @export
#' @examples
#' accounting(c("123,23.50", "(123.243)"))
accounting.character <- function(x, digits = max(get_digits(x)),
  format = "f", big.mark = ",", ...) {
  sgn <- ifelse(grepl("\\(.+\\)", x), -1, 1)
  num <- gsub("\\((.+)\\)", "\\1", gsub(big.mark, "", x, fixed = TRUE))
  copy_dim(x, accounting.default(sgn * as.numeric(num), digits = digits,
    format = format, big.mark = big.mark, ...))
}

#' Numeric vector with scientific format
#' @param x a numeric vector.
#' @param format format type passed to \code{\link{formatC}}.
#' @param ... additional parameter passed to \code{formattable}.
#' @export
#' @examples
#' scientific(1250000)
#' scientific(1253421, digits = 8)
#' scientific(1253421, digits = 8, format = "E")
scientific <- function(x, format = c("e", "E"), ...) {
  formattable(as_numeric(x), format = match.arg(format), ...)
}

#' Formattable object with prefix
#' @param x an object
#' @param prefix a character vector put in front of each non-missing
#' value in \code{x} as being formatted.
#' @param sep separator
#' @param ... additional parameter passed to \code{formattable}.
#' @param na.text text for missing values in \code{x}.
#' @export
#' @examples
#' prefix(1:10, "A")
#' prefix(1:10, "Choice", sep = " ")
#' prefix(c(1:10, NA), prefix = "A", na.text = "(missing)")
#' prefix(rnorm(10, 10), "*", format = "d")
#' prefix(percent(c(0.1,0.25)), ">")
prefix <- function(x, prefix = "", sep = "", ..., na.text = NULL) {
  formattable(x, ...,
    postproc = list(function(str, x)
      paste0(ifelse(xna <- is.na(x), "", paste0(prefix, sep)),
        if (is.null(na.text)) str else ifelse(xna, na.text, str))))
}

#' Formattable object with suffix
#' @param x an object
#' @param suffix a character vector put behind each non-missing
#' value in \code{x} as being formatted.
#' @param sep separator
#' @param ... additional parameter passed to \code{formattable}.
#' @param na.text text for missing values in \code{x}.
#' @export
#' @examples
#' suffix(1:10, "px")
#' suffix(1:10, ifelse(1:10 >= 2, "units", "unit"), sep = " ")
#' suffix(c(1:10, NA), "km/h", na.text = "(missing)")
#' suffix(percent(c(0.1, 0.25)), "*")
suffix <- function(x, suffix = "", sep = "", ..., na.text = NULL) {
  formattable(x, ...,
    postproc = list(function(str, x) {
      xna <- is.na(x)
      paste0(if (is.null(na.text)) str else ifelse(xna, na.text, str),
        ifelse(xna, "", paste0(sep, suffix)))
    }))
}
