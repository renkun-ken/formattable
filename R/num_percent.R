#' Numeric vector with percentage representation
#'
#' Formats numbers as percentages.
#'
#' @family numeric vectors
#' @param x a numeric vector.
#' @param digits an integer to indicate the number of digits of the percentage string.
#' @param format format type passed to [formatC()].
#' @param ... additional parameters passed to [formattable()].
#' @export
#' @examples
#' num_percent(rnorm(10, 0, 0.1))
#' num_percent(rnorm(10, 0, 0.1), digits = 0)
num_percent <- function(x, digits = 2L, format = "f", ...) {
  formattable(as_numeric(x),
    format = format, digits = digits,
    class = "formattable_percent",
    preproc = "percent_preproc", postproc = "percent_postproc",
    ...
  )
}

#' @rdname num_percent
#' @export
#' @examples
#' parse_percent("0.5%")
#' parse_percent(c("15.5%", "25.12%", "73.5"))
parse_percent <- function(x, digits = NA, format = "f", ...) {
  valid <- grepl("^(.+)\\s*%$", x)
  pct <- gsub("^(.+)\\s*%$", "\\1", x)
  if (is.na(digits)) digits <- max(get_digits(x) - ifelse(valid, 0, 2))
  copy_dim(x, percent.default(as.numeric(pct) / ifelse(valid, 100, 1),
    digits = digits, format = "f"
  ))
}

percent_preproc <- function(x) x * 100
percent_postproc <- function(str, x) {
  paste0(str, ifelse(is.finite(x), "%", ""))
}
