#' Numeric vector with currency format
#' @inheritParams comma
#' @param symbol currency symbol
#' @param sep separator between symbol and value
#' @export
currency <- function(x, symbol, digits,
                     format = "f", big.mark = ",", ...) {
  UseMethod("currency")
}

#' @rdname currency
#' @export
#' @examples
#' currency(200000)
#' currency(200000, "\U20AC")
#' currency(1200000, "USD", sep = " ")
#' currency(1200000, "USD", format = "d", sep = " ")
currency.default <- function(x, symbol = "$",
                             digits = 2L, format = "f", big.mark = ",", ..., sep = "") {
  x <- as_numeric(x)
  formattable(x,
    format = format, big.mark = big.mark, digits = digits, ...,
    postproc = function(str, x) {
      sprintf(
        "%s%s%s",
        ifelse(is.na(x), "", symbol), sep, str
      )
    }
  )
}

get_currency_symbol <- function(x) {
  sym <- unique(gsub("\\d|\\s|\\,|\\.", "", x))
  if (length(sym) > 1L) warning("Cannot find a unique symbol", call. = FALSE)
  sym[[1L]]
}

#' @rdname currency
#' @export
#' @examples
#' currency("$ 120,250.50")
#' currency("HK$ 120,250.50", symbol = "HK$")
#' currency("HK$ 120, 250.50")
currency.character <- function(x, symbol = get_currency_symbol(x),
                               digits = max(get_digits(x)), format = "f", big.mark = ",", ...) {
  if (any(invalid <- !grepl("\\d", x))) {
    warning("Invalid input in 'x': ", paste(x[invalid], collapse = ", "), call. = FALSE)
  }
  num <- gsub("[^0-9\\.]", "", gsub(big.mark, "", x, fixed = TRUE))
  copy_dim(x, currency.default(as.numeric(num),
    symbol = symbol, digits = digits,
    format = format, big.mark = big.mark, ...
  ))
}
