#' @export
formattable <- function(x, ...)
  UseMethod("formattable")

#' @export
formattable.default <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = "formatC",
      format = list(...), preproc = preproc, postproc = postproc))
}

#' @export
formattable.logical <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter= "ifelse",
      format = list(...), preproc = preproc, postproc = postproc))
}

#' @export
formattable.factor <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter= "vmap",
      format = list(...), preproc = preproc, postproc = postproc))
}

#' @export
formattable.Date <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = "format.Date",
      format = list(...), preproc = preproc, postproc = postproc))
}

#' @export
formattable.POSIXct <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = "format.POSIXct",
      format = list(...), preproc = preproc, postproc = postproc))
}

#' @export
formattable.POSIXlt <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = "format.POSIXlt",
      format = list(...), preproc = preproc, postproc = postproc))
}

#' @export
as.character.formattable <- function(x, ...) {
  as.character(format.formattable(x), ...)
}

#' @export
print.formattable <- function(x, ...) {
  print(format.formattable(x), ..., quote = is.character(x))
}

#' @export
format.formattable <- function(x, ...,
  justify = "none", na.encode = FALSE, trim = FALSE, use.names = TRUE) {
  attrs <- get_attr(x, "formattable")
  format_args <- attrs$format
  custom_args <- list(...)
  format_args[names(custom_args)] <- custom_args
  x_value <- remove_class(x, "formattable")
  value <- call_or_default(attrs$preproc, x_value)
  str <- do.call(attrs$formatter, c(list(value), format_args))
  if (x_atomic <- is.atomic(x)) str <- remove_attribute(str, "formattable")
  str <- call_or_default(attrs$postproc, str, x_value)
  if (use.names && x_atomic && !is.null(x_names <- names(x))) names(str) <- x_names
  str
}

#' @export
`format<-` <- function(x, value)
  UseMethod("format<-")

#' @export
`format<-.default` <- function(x, value) {
  if(!is.list(value)) stop("value must be a list", call. = FALSE)
  create_obj(x, "formattable", list(format = value))
}

#' @export
`format<-.formattable` <- function(x, value) {
  if(!is.list(value)) stop("value must be a list", call. = FALSE)
  attr(x, "format") <- value
  x
}

#' @export
`[.formattable` <- function(x, ...) {
  if(is.atomic(x)) copy_obj(x, NextMethod("["), "formattable") else NextMethod("[")
}

#' @export
`[[.formattable` <- function(x, ...) {
  if(is.atomic(x)) copy_obj(x, NextMethod("[["), "formattable") else NextMethod("[[")
}

#' @export
c.formattable <- function(x, ...) {
  if(is.atomic(x)) copy_obj(x, NextMethod("c"), "formattable") else NextMethod("c")
}

#' @export
`+.formattable` <- function(x, y) {
  copy_obj(x, NextMethod("+"), "formattable")
}

#' @export
`-.formattable` <- function(x, y) {
  copy_obj(x, NextMethod("-"), "formattable")
}

#' @export
`*.formattable` <- function(x, y) {
  copy_obj(x, NextMethod("*"), "formattable")
}

#' @export
`/.formattable` <- function(x, y) {
  copy_obj(x, NextMethod("/"), "formattable")
}

#' @export
`%%.formattable` <- function(x, y) {
  copy_obj(x, NextMethod("%%"), "formattable")
}

#' @export
rep.formattable <- function(x, ...) {
  copy_obj(x, NextMethod("rep"), "formattable")
}

#' @export
format_table <- function(x, formatter = list(),
  format = c("markdown", "pandoc"), align = "r",
  digits = getOption("digits"), ...,
  row.names = rownames(x), check.rows = FALSE, check.names = FALSE,
  envir = parent.frame()) {
  stopifnot(is.data.frame(x))
  format <- match.arg(format)
  xdf <- data.frame(mapply(function(x, name) {
    if (is.numeric(x)) {
      x <- round(x, digits)
    }
    f <- formatter[[name]]
    value <- if (is.null(f)) {
      x
    } else if (inherits(f, "formula")) {
      eval_formula(f, x, envir)
    } else {
      f <- match.fun(f)
      f(x)
    }
    as.character(value)
  }, x, names(x), SIMPLIFY = FALSE),
    row.names = row.names,
    check.rows = check.rows,
    check.names = check.names,
    stringsAsFactors = FALSE)
  knitr::kable(xdf, format = format, align = align, escape = FALSE, ...)
}

#' Create formatted table by column formatters
#'
#' This is an table generator that specializes in creating
#' formatted table presented in a mix of markdown/reStructuredText and
#' HTML elements. To generate a formatted table, each column of data
#' frame can be transformed by formatter function.
#' @param x a \code{data.frame}.
#' @param formatter A named list of formatter functions.
#' @param format The output format: markdown or pandoc?
#' @param align The alignment of columns: a character vector consisting of \code{'l'} (left),
#' \code{'c'} (center), and/or \code{'r'} (right). By default, all columns are right-aligned.
#' @param digits An integer that all numeric columns are rounded to.
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
formattable.data.frame <- function(x, ...) {
  create_obj(x, "formattable",
    list(formatter = "format_table", format = list(..., envir = parent.frame())))
}

#' @export
formattable.matrix <- function(x, ...) {
  formattable.data.frame(data.frame(x, stringsAsFactors = FALSE), ...)
}
