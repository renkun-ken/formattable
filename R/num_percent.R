percent_preproc <- function(x) x * 100
percent_postproc <- function(str, x) {
  paste0(str, ifelse(is.finite(x), "%", ""))
}

#' Numeric vector with percentage representation
#'
#' @param x a numeric vector.
#' @param digits an integer to indicate the number of digits of the percentage string.
#' @param format format type passed to [formatC()].
#' @param ... additional parameters passed to `formattable`.
#' @export
percent <- function(x, digits, format = "f", ...) {
  UseMethod("percent")
}

#' @rdname percent
#' @export
#' @examples
#' percent(rnorm(10, 0, 0.1))
#' percent(rnorm(10, 0, 0.1), digits = 0)
percent.default <- function(x, digits = 2L, format = "f", ...) {
  formattable(as_numeric(x),
    format = format, digits = digits, ...,
    preproc = "percent_preproc", postproc = "percent_postproc"
  )
}

#' @rdname percent
#' @export
#' @examples
#' percent("0.5%")
#' percent(c("15.5%", "25.12%", "73.5"))
percent.character <- function(x, digits = NA, format = "f", ...) {
  valid <- grepl("^(.+)\\s*%$", x)
  pct <- gsub("^(.+)\\s*%$", "\\1", x)
  if (is.na(digits)) digits <- max(get_digits(x) - ifelse(valid, 0, 2))
  copy_dim(x, percent.default(as.numeric(pct) / ifelse(valid, 100, 1),
    digits = digits, format = "f"
  ))
}
