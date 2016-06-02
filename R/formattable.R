#' Generic function to create formattable object
#'
#' This function is a generic function to create \code{formattable}
#' object, i.e. an object to which a formatting function and
#' related attribute are attached. The object works as ordinary object
#' yet has specially defined behavior as being printed or converted to
#' a string representation.
#'
#' @param x an object.
#' @param ... arguments to be passed to methods.
#' @export
#' @return a \code{formattable} object
formattable <- function(x, ...)
  UseMethod("formattable")

#' Test for objects of type 'formattable'
#' @param x an object
#' @return \code{TRUE} if \code{x} has class 'formattable';
#' \code{FALSE} otherwise.
#' @export
#' @examples
#' is.formattable(10)
#' is.formattable(formattable(10))
is.formattable <- function(x) {
  inherits(x, "formattable")
}

#' Create a formattable object
#' @inheritParams formattable
#' @param ... arguments to be passed to \code{formatter}.
#' @param formatter formatting function, \code{formatC} in default.
#' @param preproc pre-processor function that prepares \code{x} for
#' formatting function.
#' @param postproc post-processor function that transforms formatted
#' output for printing.
#' @export
#' @return a \code{formattable} object that inherits from the original
#' object.
#' @examples
#' formattable(rnorm(10), formatter = "formatC", digits = 1)
formattable.default <- function(x, ..., formatter,
  preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = formatter,
      format = list(...), preproc = preproc, postproc = postproc))
}

#' Create a formattable numeric vector
#' @inheritParams formattable.default
#' @param x a numeric vector.
#' @param formatter formatting function, \link{formatC} in default.
#' @export
#' @return a \code{formattable} numeric vector.
#' @examples
#' formattable(rnorm(10), format = "f", digits = 1)
#' formattable(rnorm(10), format = "f",
#'   flag="+", digits = 1)
#' formattable(1:10,
#'   postproc = function(str, x) paste0(str, "px"))
#' formattable(1:10,
#'   postproc = function(str, x)
#'     paste(str, ifelse(x <= 1, "unit", "units")))
formattable.numeric <- function(x, ..., formatter = "formatC",
  preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = formatter,
      format = list(...), preproc = preproc, postproc = postproc))
}

#' Create a formattable logical vector
#' @inheritParams formattable.default
#' @param x a logical vector.
#' @param formatter formatting function, \code{formattable::ifelse} in default.
#' @export
#' @return a \code{formattable} logical vector.
#' @examples
#' logi <- c(TRUE, TRUE, FALSE)
#' flogi <- formattable(logi, "yes", "no")
#' flogi
#' !flogi
#' any(flogi)
#' all(flogi)
formattable.logical <- function(x, ..., formatter = "ifelse",
  preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = formatter,
      format = list(...), preproc = preproc, postproc = postproc))
}

#' Create a formattable factor object
#' @inheritParams formattable.default
#' @param x a factor object.
#' @param formatter formatting function, \code{vmap} in default.
#' @export
#' @return a \code{formattable} factor object.
#' @examples
#' formattable(as.factor(c("a", "b", "b", "c")),
#'   a = "good", b = "fair", c = "bad")
formattable.factor <- function(x, ..., formatter = "vmap",
  preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = formatter,
      format = list(...), preproc = preproc, postproc = postproc))
}

#' Create a formattable Date vector
#' @inheritParams formattable.default
#' @param x a vector of class \code{Date}.
#' @param formatter formatting function, \code{format.Date} in default.
#' @export
#' @return a \code{formattable} Date vector
#' @examples
#' dates <- as.Date("2015-04-10") + 1:5
#' fdates <- formattable(dates, format = "%m/%d/%Y")
#' fdates
#' fdates + 30
formattable.Date <- function(x, ..., formatter = "format.Date",
  preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = formatter,
      format = list(...), preproc = preproc, postproc = postproc))
}

#' Create a formattable POSIXct vector
#' @inheritParams formattable.default
#' @param x a vector of class \code{POSIXct}.
#' @param formatter formatting function, \code{format.POSIXct} in default.
#' @export
#' @return a \code{formattable} POSIXct vector
#' @examples
#' times <- as.POSIXct("2015-04-10 09:30:15") + 1:5
#' ftimes <- formattable(times, format = "%Y%m%dT%H%M%S")
#' ftimes
#' ftimes + 30
formattable.POSIXct <- function(x, ..., formatter = "format.POSIXct",
  preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = formatter,
      format = list(...), preproc = preproc, postproc = postproc))
}

#' Create a formattable POSIXlt vector
#' @inheritParams formattable.default
#' @param x a vector of class \code{POSIXlt}.
#' @param formatter formatting function, \code{format.POSIXlt} in default.
#' @export
#' @return a \code{formattable} POSIXlt vector
#' @examples
#' times <- as.POSIXlt("2015-04-10 09:30:15") + 1:5
#' ftimes <- formattable(times, format = "%Y%m%dT%H%M%S")
#' ftimes
#' ftimes + 30
formattable.POSIXlt <- function(x, ..., formatter = "format.POSIXlt",
  preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = formatter,
      format = list(...), preproc = preproc, postproc = postproc))
}

#' @export
formattable.formattable <- function(x, ..., formatter, preproc, postproc) {
  attrs <- attr(x, "formattable", exact = TRUE)
  if (!missing(formatter)) attrs$formatter <- formatter
  if (!missing(...)) attrs$format <- list(...)
  if (!missing(preproc))
    attrs$preproc <- if (is.list(preproc)) c(preproc, attrs$preproc) else preproc
  if (!missing(postproc))
    attrs$postproc <- if (is.list(postproc)) c(attrs$postproc, postproc) else postproc
  attr(x, "formattable") <- attrs
  x
}

#' @export
as.character.formattable <- function(x, ...) {
  format.formattable(x)
}

print_formattable <- function(x, ...)
  UseMethod("print_formattable")

print_formattable.default <- function(x, ...) {
  if (length(x) == 0L) cat(sprintf("%s(0)", paste0(class(x), collapse = " ")))
  else {
    args <- list(...)
    print_args <- attr(x, "formattable", exact = TRUE)$print
    if (is.null(print_args)) print_args <- list()
    print_args[names(args)] <- args
    if (is.null(print_args$quote)) print_args$quote <- is.character(x)
    do.call(print, c(list(format.formattable(x)), print_args))
  }
  invisible(x)
}

print_formattable.data.frame <- function(x, ...) {
  print(as.htmlwidget(x), ...)
}

#' @export
print.formattable <- function(x, ...) {
  print_formattable(x, ...)
}

knit_print_formattable <- function(x, ...)
  UseMethod("knit_print_formattable")

knit_print_formattable.default <- print_formattable.default

#' @importFrom knitr asis_output
knit_print_formattable.data.frame <- function(x, ...) {
  format <- attr(x, "formattable", exact = TRUE)$format
  caption <- if (isTRUE(format$format == "pandoc" && nzchar(format$caption))) "<!-- -->\n\n" else ""
  asis_output(sprintf("\n%s%s\n", caption, paste0(as.character(x), collapse = "\n")))
}

#' @export
#' @importFrom knitr knit_print
knit_print.formattable <- function(x, ...)
  knit_print_formattable(x, ...)

#' @export
format.formattable <- function(x, ...,
  format = NULL,
  justify = "none", na.encode = FALSE, trim = FALSE, use.names = TRUE) {
  attrs <- attr(x, "formattable", exact = TRUE)
  if (is.null(attrs)) return(NextMethod("format"))
  format_args <- attrs$format
  format_args[names(format)] <- format
  value <- remove_class(x, "formattable")
  if (length(attrs$preproc)) {
    preproc_list <- if (is.list(attrs$preproc)) attrs$preproc else list(attrs$preproc)
    for (preproc in preproc_list) value <- call_or_default(preproc, value)
  }
  str <- do.call(attrs$formatter, c(list(value), format_args))
  if (x_atomic <- is.atomic(x)) str <- remove_attribute(str, "formattable")
  if (length(attrs$postproc)) {
    postproc_list <- if (is.list(attrs$postproc)) attrs$postproc else list(attrs$postproc)
    for (postproc in postproc_list) str <- call_or_default(postproc, str, value)
  }
  str <- as.character(str)
  if (use.names && x_atomic) {
    if (is.matrix(x)) {
      dim(str) <- dim(x)
      dimnames(str) <- dimnames(x)
    } else {
      names(str) <- names(x)
    }
  }
  str
}

#' @export
as.list.formattable <- function(x, ...) {
  lapply(seq_along(x), function(i) x[[i]])
}

#' @export
`[.formattable` <- function(x, ...) {
  value <- NextMethod("[")
  if (is.atomic(x) || is.data.frame(x))
    copy_obj(x, value, "formattable")
  else value
}

#' @export
`[<-.formattable` <- function(x, ..., value) {
  value <- NextMethod("[<-")
  reset_class(x, value, "formattable")
}

#' @export
`[[.formattable` <- function(x, ...) {
  value <- NextMethod("[[")
  if (is.atomic(x))
    copy_obj(x, value, "formattable")
  else value
}

#' @export
`[[<-.formattable` <- function(x, ..., value) {
  value <- NextMethod("[[<-")
  reset_class(x, value, "formattable")
}

#' @export
c.formattable <- function(..., recursive = FALSE) {
  fcreate_obj(c, "formattable", ...)
}

#' @export
`+.formattable` <- function(x, y) {
  cop_create_obj(`+`, "formattable", x, y)
}

#' @export
`-.formattable` <- function(x, y) {
  cop_create_obj(`-`, "formattable", x, y)
}

#' @export
`*.formattable` <- function(x, y) {
  cop_create_obj(`*`, "formattable", x, y)
}

#' @export
`/.formattable` <- function(x, y) {
  fcreate_obj(`/`, "formattable", x, unclass(y))
}

#' @export
`%%.formattable` <- function(x, y) {
  fcreate_obj(`%%`, "formattable", x, unclass(y))
}

#' @export
rep.formattable <- function(x, ...) {
  fcreate_obj(rep, "formattable", x, ...)
}

#' @export
`&.formattable` <- function(x, y) {
  fcreate_obj(`&`, "formattable", x, unclass(y))
}

#' @export
`|.formattable` <- function(x, y) {
  fcreate_obj(`|`, "formattable", x, unclass(y))
}

#' @export
all.formattable <- function(...) {
  fcreate_obj(all, "formattable", ...)
}

#' @export
any.formattable <- function(...) {
  fcreate_obj(any, "formattable", ...)
}

#' @export
max.formattable <- function(...) {
  fcreate_obj(max, "formattable", ...)
}

#' @export
min.formattable <- function(...) {
  fcreate_obj(min, "formattable", ...)
}

#' @export
sum.formattable <- function(...) {
  fcreate_obj(sum, "formattable", ...)
}

#' @export
mean.formattable <- function(x, ...) {
  fcreate_obj(mean, "formattable", x, ...)
}

#' @export
unique.formattable <- function(x, ...) {
  fcreate_obj(unique, "formattable", x, ...)
}

#' @export
diff.formattable <- function(x, ...) {
  fcreate_obj(diff, "formattable", x, ...)
}

#' @export
cummax.formattable <- function(x, ...) {
  fcreate_obj(cummax, "formattable", x, ...)
}

#' @export
cummin.formattable <- function(x, ...) {
  fcreate_obj(cummin, "formattable", x, ...)
}

#' @export
cumsum.formattable <- function(x, ...) {
  fcreate_obj(cumsum, "formattable", x, ...)
}

#' @importFrom stats median
#' @export
median.formattable <- function(x, ...) {
  fcreate_obj(median, "formattable", x, ...)
}

#' @importFrom stats quantile
#' @export
quantile.formattable <- function(x, ...) {
  fcreate_obj(quantile, "formattable", x, ...)
}

#' Format a data frame with formatter functions
#'
#' This is an table generator that specializes in creating
#' formatted table presented in a mix of markdown/reStructuredText and
#' HTML elements. To generate a formatted table, each column of data
#' frame can be transformed by formatter function.
#' @importFrom knitr kable
#' @param x a \code{data.frame}.
#' @param formatters a list of formatter functions or formulas.
#' The existing columns of \code{x} will be applied the formatter
#' function in \code{formatters} if it exists.
#'
#' If a formatter is specified by formula, then the formula will be
#' interpreted as a lambda expression with its left-hand side being
#' a symbol and right-hand side being the expression using the symbol
#' to represent the column values. The formula expression will be evaluated
#' in \code{envir}, that, to maintain consistency, should be the calling
#' environment in which the formula is created and all symbols are defined
#' at runtime.
#' @param format The output format: markdown or pandoc?
#' @param align The alignment of columns: a character vector consisting
#' of \code{'l'} (left), \code{'c'} (center), and/or \code{'r'} (right).
#' By default, all columns are right-aligned.
#' @param ... additional parameters to be passed to \code{knitr::kable}.
#' @param digits The number of significant digits to be used for numeric
#'     and complex values.
#' @param table.attr The HTML class of \code{<table>} created when
#'     \code{format = "html"}
#' @return a \code{knitr_kable} object whose \code{print} method generates a
#' string-representation of \code{data} formatted by \code{formatter} in
#' specific \code{format}.
#' @export
#' @examples
#' # mtcars (mpg in red)
#' format_table(mtcars,
#'    list(mpg = formatter("span", style = "color:red")))
#'
#' # mtcars (mpg in red if greater than median)
#' format_table(mtcars, list(mpg = formatter("span",
#'    style = function(x) ifelse(x > median(x), "color:red", NA))))
#'
#' # mtcars (mpg in red if greater than median, using formula)
#' format_table(mtcars, list(mpg = formatter("span",
#'    style = x ~ ifelse(x > median(x), "color:red", NA))))
#'
#' # mtcars (mpg in gradient: the higher, the redder)
#' format_table(mtcars, list(mpg = formatter("span",
#'    style = x ~ style(color = rgb(x/max(x), 0, 0)))))
#'
#' # mtcars (mpg background in gradient: the higher, the redder)
#' format_table(mtcars, list(mpg = formatter("span",
#'    style = x ~ style(display = "block",
#'    "border-radius" = "4px",
#'    "padding-right" = "4px",
#'    color = "white",
#'    "background-color" = rgb(x/max(x), 0, 0)))))
#'
#' # mtcars (mpg in red if vs == 1 and am == 1)
#' format_table(mtcars, list(mpg = formatter("span",
#'     style = ~ style(color = ifelse(vs == 1 & am == 1, "red", NA)))))
format_table <- function(x, formatters = list(),
  format = c("html", "markdown", "pandoc"), align = "r", ...,
  digits = getOption("digits"), table.attr = 'class="table table-condensed"') {
  stopifnot(is.data.frame(x))
  if (nrow(x) == 0L) formatters <- list()
  format <- match.arg(format)
  cols <- colnames(x)
  mat <- vapply(x, base_format, character(nrow(x)), digits = digits)
  dim(mat) <- dim(x)
  dimnames(mat) <- dimnames(x)
  for (fi in seq_along(formatters)) {
    fn <- names(formatters)[[fi]]
    f <- formatters[[fi]]
    if (!is.null(fn) && nzchar(fn)) {
      if (fn %in% cols) {
        value <- x[, fn]
        fv <-  if (inherits(f, "formatter")) f(value, x)
        else  if (inherits(f, "formula")) eval_formula(f, value, x)
        else match.fun(f)(value)
        mat[, fn] <- format(fv)
      }
    } else if (inherits(f, "formula")) {
      fenv <- environment(f)
      value <- as.matrix(if (length(f) == 2L) {
        row <- col <- TRUE
        f <- eval(f[[2L]], fenv)
        x
      } else {
        farea <- eval(f[[2L]], fenv)
        row <- eval(farea$row, seq_list(rownames(x)), farea$envir)
        col <- eval(farea$col, seq_list(colnames(x)), farea$envir)
        f <- eval(f[[3L]], fenv)
        x[row, col]
      })
      fv <-  if (inherits(f, "formatter")) f(value, x) else match.fun(f)(value)
      mat[row, col] <- format(fv)
    }
  }

  kable(mat, format = format, align = align, escape = FALSE, ...,
    table.attr = table.attr)
}

#' Create a formattable data frame
#'
#' This function creates a formattable data frame by attaching
#' column formatters to the data frame. Each time the data frame
#' is printed or converted to string representation, the formatter
#' function will use the column formatter functions to generate
#' formatted columns.
#'
#' @details
#' The formattable data frame is a data frame with lazy-bindings
#' of prespecified column formatters. The formatters will not be
#' applied until the data frame is printed to console or a
#' dynamic document. If the formatter function has no side effect,
#' the formattable data frame will not be changed even if the
#' formatters are applied to produce the printed version.
#'
#' @inheritParams formattable.default
#' @param x a \code{data.frame}
#' @param formatter formatting function, \code{format_table} in default.
#' @export
#' @return a \code{formattable data.frame}
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
#'
#' # mtcars (mpg in red if vs == 1 and am == 1)
#' formattable(mtcars, list(mpg = formatter("span",
#'     style = ~ style(color = ifelse(vs == 1 & am == 1, "red", NA)))))
formattable.data.frame <- function(x, ..., formatter = "format_table",
  preproc = NULL, postproc = NULL) {
  create_obj(x, "formattable",
    list(formatter = formatter, format = list(...),
      preproc = preproc, postproc = postproc))
}
