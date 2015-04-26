#' Create formatted table by column formatters
#'
#' This is an table generator that specializes in creating
#' formatted table presented in a mix of markdown/reStructuredText and
#' HTML elements. To generate a formatted table, each column of data
#' frame can be transformed by formatter function.
#' @param x data
#' @param ... additional parameters
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
formattable <- function(x, ...)
  UseMethod("formattable")

create_obj0 <- function(x, class, attributes) {
  attributes(x) <- attributes
  if (!(class %in% (cls <- class(x))))
    class(x) <- c(class, cls)
  x
}

create_obj <- function(x, class, ...) {
  create_obj0(x, class, list(...))
}

remove_class <- function(x, class) {
  cls <- class(x)
  class(x) <- cls[!(cls %in% class)]
  x
}

remove_attributes <- function(x) {
  attributes(x) <- NULL
  x
}

attr_default <- function(..., default = NULL) {
  if (is.null(value <- attr(...))) default else value
}

#' @export
formattable.default <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable", formatter = "formatC",
    format = list(...), preproc = preproc, postproc = postproc)
}

#' @export
formattable.logical <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable", formatter= "ifelse",
    format = list(...), preproc = preproc, postproc = postproc)
}

#' @export
formattable.Date <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable", formatter = "format",
    format = list(...), preproc = preproc, postproc = postproc)
}

#' @export
formattable.POSIXct <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable", formatter = "format",
    format = list(...), preproc = preproc, postproc = postproc)
}

#' @export
formattable.POSIXlt <- function(x, ..., preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable", formatter = "format",
    format = list(...), preproc = preproc, postproc = postproc)
}

fcall <- function(FUN, X, ...) {
  if (is.null(FUN)) X else match.fun(FUN)(X, ...)
}

#' @export
as.character.formattable <- function(x, ...) {
  format.formattable(x, ...)
}

#' @export
print.formattable <- function(x, ...) {
  print(as.character.formattable(x), ..., quote = is.character(x))
}

#' @export
format.formattable <- function(x, ...,
  justify = "none", na.encode = FALSE, trim = FALSE) {
  formatter <- attr(x, "formatter", exact = TRUE)
  format_args <- attr(x, "format", exact = TRUE)
  custom_args <- list(...)
  format_args[names(custom_args)] <- custom_args
  x_value <- remove_class(x, "formattable")
  value <- fcall(attr(x, "preproc", exact = TRUE), x_value)
  str <- remove_attributes(do.call(formatter, c(list(value), format_args)))
  fcall(attr(x, "postproc", exact = TRUE), str, x_value)
}

#' @export
`format<-` <- function(x, value)
  UseMethod("format<-")

#' @export
`format<-.default` <- function(x, value) {
  if(!is.list(value)) stop("value must be a list", call. = FALSE)
  create_obj(x, "formattable", format = value)
}

#' @export
`format<-.formattable` <- function(x, value) {
  if(!is.list(value)) stop("value must be a list", call. = FALSE)
  attr(x, "format") <- value
  x
}

#' @export
`[.formattable` <- function(x, ...) {
  create_obj0(NextMethod("["), "formattable", attributes(x))
}

#' @export
`[[.formattable` <- function(x, ...) {
  create_obj0(NextMethod("[["), "formattable", attributes(x))
}

#' @export
c.formattable <- function(x, ...) {
  create_obj0(NextMethod("c"), "formattable", attributes(x))
}

#' @export
`+.formattable` <- function(x, y) {
  create_obj0(NextMethod("+"), "formattable", attributes(x))
}

#' @export
`-.formattable` <- function(x, y) {
  create_obj0(NextMethod("-"), "formattable", attributes(x))
}

#' @export
`*.formattable` <- function(x, y) {
  create_obj0(NextMethod("*"), "formattable", attributes(x))
}

#' @export
`/.formattable` <- function(x, y) {
  create_obj0(NextMethod("/"), "formattable", attributes(x))
}

#' @export
`%%.formattable` <- function(x, y) {
  create_obj0(NextMethod("%%"), "formattable", attributes(x))
}

#' @export
rep.formattable <- function(x, ...) {
  create_obj0(NextMethod("rep"), "formattable", attributes(x))
}

#' @rdname formattable
#' @param formatter A named list of formatter functions.
#' @param format The output format: markdown or pandoc?
#' @param align The alignment of columns: a character vector consisting of \code{'l'} (left),
#' \code{'c'} (center), and/or \code{'r'} (right). By default, all columns are right-aligned.
#' @param digits An integer that all numeric columns are rounded to.
#' @export
formattable.data.frame <- function(x, formatter = list(),
  format = c("markdown", "pandoc"), align = "r", digits = getOption("digits"), ...) {
  format <- match.arg(format)
  envir <- parent.frame()
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
    row.names = row.names(x), stringsAsFactors = FALSE)
  knitr::kable(xdf, format = format, align = align, escape = FALSE, ...)
}

#' @export
formattable.matrix <- function(x, formatter = list(), ...) {
  formattable.data.frame(data.frame(x, stringsAsFactors = FALSE), formatter = formatter, ...)
}
