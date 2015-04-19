#' Create formatted table by column formatters
#'
#' This is an table generator that specializes in creating
#' formatted table presented in a mix of markdown/reStructuredText and
#' HTML elements. To generate a formatted table, each column of data
#' frame can be transformed by formatter function.
#' @param data data
#' @param formatter A named list of formatter functions.
#' @param ... additional parameters passed to \code{knitr::kable}
#' @export
#' @return a \code{knitr_kable} object whose \code{print} method generates a
#' string-representation of \code{data} formatted by \code{formatter} in specific \code{format}.
#' @examples
#' # mtcars (mpg in red)
#' formattable(mtcars,
#'    list(mpg = formatter("span", style = "color:red")))
#'
#' # mtcars (mpg in red if greater than median)
#' formattable(mtcars, list(mpg = formatter("span",
#'    style = function(x) ifelse(x > median(x), "color:red", NA))))
#'
#' # mtcars (mpg in red if greater than median, using formula)
#' formattable(mtcars, list(mpg = formatter("span",
#'    style = x ~ ifelse(x > median(x), "color:red", NA))))
#'
#' # mtcars (mpg in gradient: the higher, the redder)
#' formattable(mtcars, list(mpg = formatter("span",
#'    style = x ~ style(color = rgb(x/max(x), 0, 0)))))
#'
#' # mtcars (mpg background in gradient: the higher, the redder)
#' formattable(mtcars, list(mpg = formatter("span",
#'    style = x ~ style(display = "block",
#'    "border-radius" = "4px",
#'    "padding-right" = "4px",
#'    color = "white",
#'    "background-color" = rgb(x/max(x), 0, 0)))))
formattable <- function(data, formatter = list(), ...)
  UseMethod("formattable")

#' @rdname formattable
#' @param format The output format: markdown or pandoc?
#' @param align The alignment of columns: a character vector consisting of \code{'l'} (left),
#' \code{'c'} (center), and/or \code{'r'} (right). By default, all columns are right-aligned.
#' @param digits An integer that all numeric columns are rounded to.
#' @export
formattable.data.frame <- function(data, formatter = list(),
  format = c("markdown", "pandoc"), align = "r", digits = getOption("digits"), ...) {
  format <- match.arg(format)
  envir <- parent.frame()
  xdf <- data.frame(mapply(function(x, name) {
    if (is.numeric(x)) {
      x <- round(x, digits)
    }
    f <- formatter[[name]]
    if (is.null(f)) {
      x
    } else if (inherits(f, "formula")) {
      eval_formula(f, x, envir)
    } else {
      f <- match.fun(f)
      f(x)
    }
  }, data, names(data), SIMPLIFY = FALSE),
    row.names = row.names(data), stringsAsFactors = FALSE)
  knitr::kable(xdf, format = format, align = align, escape = FALSE, ...)
}

#' @rdname formattable
#' @export
formattable.matrix <- function(data, formatter = list(), ...) {
  formattable.data.frame(data.frame(data, stringsAsFactors = FALSE), formatter = formatter, ...)
}
