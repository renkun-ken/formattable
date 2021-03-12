#' Create a formatter function making HTML elements
#'
#' @details
#' This function creates a `formatter` object which is essentially a
#' closure taking a value and optionally the dataset behind.
#'
#' The formatter produces a character vector of HTML elements represented
#' as strings. The tag name of the elements are specified by `.tag`,
#' and its attributes are calculated with the given functions or formulas
#' specified in `...` given the input vector and/or dataset in behind.
#'
#' Formula like `x ~ expr` will behave like `function(x) expr`.
#' Formula like `~expr` will be evaluated in different manner: `expr`
#' will be evaluated in the data frame with the enclosing environment being
#' the formula environment. If a column is formatted according to multiple
#' other columns, `~expr` should be used and the column names can directly
#' appear in `expr`.
#' @param .tag HTML tag name. Uses `span` by default.
#' @param ... functions to create attributes of HTML element from data colums.
#' The unnamed element will serve as the function to produce the inner text of the
#' element. If no unnamed element is provided, `identity` function will be used
#' to preserve the string representation of the colum values. Function and formula are
#' accepted. See details for how different forms of formula will behave differently.
#' @return a function that transforms a column of data (usually an atomic vector)
#' to formatted data represented in HTML and CSS.
#' @examples
#' top10red <- formatter("span",
#'   style = x ~ ifelse(rank(-x) <= 10, "color:red", NA))
#' yesno <- function(x) ifelse(x, "yes", "no")
#' formattable(mtcars, list(mpg = top10red, qsec = top10red, am = yesno))
#'
#' # format one column by other two columns
#' # make cyl red for records with both mpg and disp rank <= 20
#' f1 <- formatter("span",
#'   style = ~ ifelse(rank(-mpg) <= 20 & rank(-disp) <= 20, "color:red", NA))
#' formattable(mtcars, list(cyl = f1))
#' @export
formatter <- function(.tag, ...) {
  check_installed("htmltools")

  fcall <- match.call(expand.dots = TRUE)
  args <- list(...)

  use_text <- length(args) == 0L ||
    (!is.null(argnames <- names(args)) && all(nzchar(argnames)))

  # create a closure for formattable to build output string
  structure(function(x, data = NULL, text = format(x, trim = TRUE)) {
    if (length(x) == 0L && length(data) == 0L) return(character())
    values <- c(lapply(args, function(arg) {
      value <- if (is.function(arg)) arg(x)
      else if (inherits(arg, "formula")) eval_formula(arg, x, data)
      else arg
      if (is.null(value)) NA else value
    }), if (use_text) list(text))
    tags <- if (length(x) == 1L) {
      list(htmltools::tag(.tag, values[!is.na(values) & nzchar(values)]))
    } else {
      .mapply(function(...) {
        attrs <- list(...)
        htmltools::tag(.tag, attrs[!is.na(attrs) & nzchar(attrs)])
      }, values, NULL)
    }
    copy_dim(x, vapply(tags, htmltools::doRenderTags, character(1L)))
  }, class = c("formatter", "function"))
}

#' @export
print.formatter <- function(x, ...) {
  env <- environment(x)
  print(env$fcall, ...)
  invisible(x)
}

#' Create an area to apply formatter
#'
#' Create an representation of two-dimenstional area
#' to apply formatter function. The area can be one or
#' more columns, one or more rows, or an area of rows
#' and columns.
#'
#' @details
#' The function creates an `area` object to store
#' the representation of row and column selector expressions.
#' When the function is called, the expressions and environment
#' of `row` and `column` are captured for
#' [format_table()] to evaluate within the context of the
#' input `data.frame`, that is, `rownames` and
#' `colnames` are defined in the context to be the indices
#' of rows and columns, respectively. Therefore, the row names
#' and column names are avaiable symbols when `row`
#' and `col` are evaluated, respectively, which makes it
#' easier to specify range with names, for example,
#' `area(row = row1:row10, col = col1:col5)`.
#'
#' @param row an expression of row range. If missing,
#' `TRUE` is used instead.
#' @param col an expression of column range. If missing,
#' `TRUE` is used instead.
#' @export
#' @examples
#' area(col = c("mpg", "cyl"))
#' area(col = mpg:cyl)
#' area(row = 1)
#' area(row = 1:10, col = 5:10)
#' area(1:10, col1:col5)
#' @seealso [format_table], [formattable.data.frame]
area <- function(row, col) {
  structure(list(
    row = if (missing(row)) TRUE else substitute(row),
    col = if (missing(col)) TRUE else substitute(col),
    envir = parent.frame()),
    class = "area")
}

#' Create a color-tile formatter
#'
#' @param ... parameters passed to [gradient()].
#' @export
#' @examples
#' formattable(mtcars, list(mpg = color_tile("white", "pink")))
color_tile <- function(...) {
  formatter("span",
    style = function(x) style(
      display = "block",
      padding = "0 4px",
      "border-radius" = "4px",
      "background-color" = csscolor(gradient(as.numeric(x), ...))))
}

#' Create a color-bar formatter
#'
#' @param color the background color of the bars
#' @param fun the transform function that maps the input vector to
#' values from 0 to 1. Uses [proportion()] by default.
#' @param ... additional parameters passed to `fun`
#' @export
#' @examples
#' formattable(mtcars, list(mpg = color_bar("lightgray", proportion)))
#' @seealso
#' [normalize_bar()], [proportion_bar()]
color_bar <- function(color = "lightgray", fun = "proportion", ...) {
  fun <- match.fun(fun)
  formatter("span",
    style = function(x) style(
      display = "inline-block",
      direction = "rtl",
      "unicode-bidi" = "plaintext",
      "border-radius" = "4px",
      "padding-right" = "2px",
      "background-color" = csscolor(color),
      width = percent(fun(as.numeric(x), ...))
    ))
}

#' Create a color-bar formatter using normalize
#'
#' @param color the background color of the bars
#' @param ... additional parameters passed to [normalize()]
#' @export
#' @examples
#' formattable(mtcars, list(mpg = normalize_bar()))
#' @seealso
#' [color_bar()], [normalize()]
normalize_bar <- function(color = "lightgray", ...) {
  color_bar(color = color, fun = normalize, ...)
}

#' Create a color-bar formatter using proportion
#'
#' @param color the background color of the bars
#' @param ... additional parameters passed to [proportion()]
#' @export
#' @examples
#' formattable(mtcars, list(mpg = proportion_bar()))
#' @seealso
#' [color_bar()], [proportion()]
proportion_bar <- function(color = "lightgray", ...) {
  color_bar(color = color, fun = proportion, ...)
}

#' Create a color-text formatter
#'
#' @param ... parameters passed to [gradient()].
#' @export
#' @examples
#' formattable(mtcars, list(mpg = color_text("black", "red")))
color_text <- function(...) {
  formatter("span",
    style = function(x) style(
      color = csscolor(gradient(as.numeric(x), ...))))
}
