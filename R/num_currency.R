#' Numeric vector with currency format
#'
#' Formats numbers with a thousand separator
#' and a currency indicator.
#'
#' @family numeric vectors
#' @inheritParams num_comma
#' @param symbol currency symbol
#' @param sep separator between symbol and value
#' @export
#' @examples
#' num_currency(200000)
#' num_currency(200000, "\U20AC")
#' num_currency(1200000, "USD", sep = " ")
#' num_currency(1200000, "USD", format = "d", sep = " ")
num_currency <- function(x, symbol = "$",
                         digits = 2L, format = "f", big.mark = ",", ..., sep = "") {
  x <- as_numeric(x)
  formattable(x,
    format = format, big.mark = big.mark, digits = digits,
    class = "formattable_currency",
    postproc = function(str, x) {
      sprintf(
        "%s%s%s",
        ifelse(is.na(x), "", symbol), sep, str
      )
    },
    symbol = symbol,
    ...
  )
}

get_currency_symbol <- function(x) {
  sym <- unique(gsub("\\d|\\s|\\,|\\.", "", x))
  if (length(sym) > 1L) warning("Cannot find a unique symbol", call. = FALSE)
  sym[[1L]]
}

#' @rdname num_currency
#' @export
#' @examples
#' parse_currency("$ 120,250.50")
#' parse_currency("HK$ 120,250.50", symbol = "HK$")
#' parse_currency("HK$ 120, 250.50")
parse_currency <- function(x, symbol = get_currency_symbol(x),
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
