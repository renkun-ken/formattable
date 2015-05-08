#' Numeric vector with percentage format
#'
#' @param x a numeric vector.
#' @param digits an integer to indicate the number of digits of the percentage string.
#' @param format format type passed to \code{\link{formatC}}.
#' @param ... additional parameters passed to \code{formattable}.
#' @export
#' @examples
#' percent(rnorm(10, 0, 0.1))
#' percent(rnorm(10, 0, 0.1), digits = 0)
percent <- function(x, digits = 2L, format = "f", ...) {
  stopifnot(is.numeric(x))
  formattable(x, format = format, digits = digits, ...,
    preproc = function(x) x * 100,
    postproc = function(str, x) paste0(str, ifelse(is.finite(x), "%", "")))
}

#' Numeric vector with thousands separators
#' @inheritParams percent
#' @param big.mark thousands separator
#' @export
#' @examples
#' comma(1000000)
#' comma(c(1250000, 225000))
#' comma(c(1250000, 225000), format = "d")
comma <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  stopifnot(is.numeric(x))
  formattable(x, format = format, big.mark = big.mark, digits = digits, ...)
}

#' Numeric vector with currency format
#' @inheritParams comma
#' @param symbol currency symbol
#' @param sep separator between symbol and value
#' @export
#' @examples
#' currency(200000)
#' currency(200000, "\U20AC")
#' currency(1200000, "USD", sep = " ")
#' currency(1200000, "USD", format = "d", sep = " ")
currency <- function(x, symbol = "$",
  digits = 2L, format = "f", big.mark = ",", ..., sep = "") {
  stopifnot(is.numeric(x))
  formattable(x, format = format, big.mark = big.mark, digits = digits, ...,
    postproc = function(str, x) paste(symbol, str, sep = sep))
}

#' Numeric vector with accounting format
#' @inheritParams comma
#' @export
#' @examples
#' accounting(15320)
#' accounting(-12500)
#' accounting(c(1200, -3500, 2600), format = "d")
accounting <- function(x, digits = 2L, format = "f", big.mark = ",", ...) {
  stopifnot(is.numeric(x))
  formattable(x, format = format, big.mark = big.mark, digits = digits, ...,
    postproc = function(str, x)
      sprintf(ifelse(x >= 0, "%s", "(%s)"), gsub("-", "", str, fixed = TRUE)))
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
  stopifnot(is.numeric(x))
  formattable(x, format = match.arg(format), ...)
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
prefix <- function(x, prefix = "", sep = "", ..., na.text = NULL) {
  formattable(x, ...,
    preproc = NULL,
    postproc = function(str, x)
      paste0(ifelse(xna <- is.na(x), "", paste0(prefix, sep)),
        if(is.null(na.text)) str else ifelse(xna, na.text, str)))
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
suffix <- function(x, suffix = "", sep = "", ..., na.text = NULL) {
  formattable(x, ...,
    preproc = NULL,
    postproc = function(str, x) {
      xna <- is.na(x)
      paste0(if(is.null(na.text)) str else ifelse(xna, na.text, str),
        ifelse(xna, "", paste0(sep, suffix)))
    })
}
