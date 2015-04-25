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
  if (!(class %in% (cls <- class(x))))
    class(x) <- c(class, cls)
  .mapply(function(name, value) {
    attr(x, name) <<- value
  }, list(names(attributes), attributes), NULL)
  x
}

create_obj <- function(x, class, ...) {
  create_obj0(x, class, list(...))
}

unclass_obj <- function(x, class) {
  cls <- class(x)
  class(x) <- cls[!(cls %in% class)]
  x
}

attr_default <- function(..., default = NULL) {
  if (is.null(value <- attr(...))) default else value
}

#' @export
formattable.default <- function(x, ..., prefix = "", suffix = "") {
  create_obj(x, "formattable", formatter = "formatC",
    format = list(...), prefix = prefix, suffix = suffix)
}

#' @export
formattable.Date <- function(x, ...) {
  create_obj(x, "formattable", formatter = "format",
    format = list(...))
}

#' @export
formattable.POSIXct <- function(x, ...) {
  create_obj(x, "formattable", formatter = "format",
    format = list(...))
}

#' @export
formattable.POSIXlt <- function(x, ...) {
  create_obj(x, "formattable", formatter = "format",
    format = list(...))
}

#' @export
as.character.formattable <- function(x, ...,
  justify = "none", na.encode = FALSE, trim = FALSE) {
  formatter <- attr(x, "formatter", exact = TRUE)
  format_args <- attr(x, "format", exact = TRUE)
  custom_args <- list(...)
  format_args[names(custom_args)] <- custom_args
  str <- do.call(formatter, c(list(unclass_obj(x, "formattable")), format_args))
  prefix <- ifelse(is.na(x), "", attr_default(x, "prefix", exact = TRUE, default = ""))
  suffix <- ifelse(is.na(x), "", attr_default(x, "suffix", exact = TRUE, default = ""))
  paste0(prefix, str, suffix)
}

#' @export
print.formattable <- function(x, ...) {
  print(as.character.formattable(x), ..., quote = is.character(x))
}

#' @export
format.formattable <- function(x, ...) {
  as.character.formattable(x, ...)
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
