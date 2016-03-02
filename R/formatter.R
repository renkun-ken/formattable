#' Create a formatter function making HTML elements
#'
#' @details
#' This function creates a \code{formatter} object which is essentially a
#' closure taking a value and optionally the dataset behind.
#'
#' The formatter produces a character vector of HTML elements represented
#' as strings. The tag name of the elements are specified by \code{.tag},
#' and its attributes are calculated with the given functions or formulas
#' specified in \code{...} given the input vector and/or dataset in behind.
#'
#' Formula like \code{x ~ expr} will behave like \code{function(x) expr}.
#' Formula like \code{~expr} will be evaluated in different manner: \code{expr}
#' will be evaluated in the data frame with the enclosing environment being
#' the formula environment. If a column is formatted according to multiple
#' other columns, \code{~expr} should be used and the column names can directly
#' appear in \code{expr}.
#' @importFrom htmltools tag
#' @param .tag HTML tag name
#' @param ... functions to create attributes of HTML element from data colums.
#' The unnamed element will serve as the function to produce the inner text of the
#' element. If no unnamed element is provided, \code{identity} function will be used
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
  fcall <- match.call(expand.dots = TRUE)
  args <- list(...)
  # if function to specify element inner text is missing,
  # then use identify to preserve the default text of
  # the column value
  if (length(args) == 0L ||
      (!is.null(argnames <- names(args)) && all(nzchar(argnames)))) {
    args <- c(args, identity)
  }

  # create a closure for formattable to build output string
  structure(function(x, data = NULL) {
    if (length(x) == 0L && length(data) == 0L) return(character())
    values <- lapply(args, function(arg) {
      value <- if (is.function(arg)) arg(x)
      else if (inherits(arg, "formula")) eval_formula(arg, x, data)
      else arg
      if (is.null(value)) NA else value
    })
    tags <- if (length(x) == 1L) {
      list(tag(.tag, values[!is.na(values) & nzchar(values)]))
    } else {
      .mapply(function(...) {
        attrs <- list(...)
        tag(.tag, attrs[!is.na(attrs) & nzchar(attrs)])
      }, values, NULL)
    }
    vapply(tags, as.character, character(1L))
  }, class = c("formatter", "function"))
}

#' @export
print.formatter <- function(x, ...) {
  env <- environment(x)
  print(env$fcall, ...)
  invisible(x)
}

#' Create a color-tile formatter
#'
#' @param ... parameters passed to \code{gradient}.
#' @export
#' @examples
#' formattable(mtcars, list(mpg = color_tile("white", "pink")))
color_tile <- function(...) {
  formatter("span",
    style = function(x) style(
      display = "block",
      padding = "0 4px",
      direction = "rtl",
      "border-radius" = "4px",
      "background-color" = csscolor(gradient(x, ...))))
}

#' Create a color-bar formatter
#'
#' @param color the background color of the bars
#' @param fun the transform function that maps the input vector to
#' values from 0 to 1
#' @param ... additional parameters passed to \code{fun}
#' @export
#' @examples
#' formattable(mtcars, list(mpg = color_bar("lightgray", proportion)))
#' @seealso
#' \link{normalize_bar}, \link{proportion_bar}
color_bar <- function(color, fun, ...) {
  fun <- match.fun(fun)
  formatter("span",
    style = function(x) style(
      display = "block",
      direction = "rtl",
      "border-radius" = "4px",
      "padding-right" = "2px",
      "background-color" = csscolor(color),
      width = percent(fun(x, ...))
    ))
}

#' Create a color-bar formatter using normalize
#'
#' @param color the background color of the bars
#' @param ... additional parameters passed to \code{normalize}
#' @export
#' @examples
#' formattable(mtcars, list(mpg = normalize_bar()))
#' @seealso
#' \link{color_bar}, \link{normalize}
normalize_bar <- function(color = "lightgray", ...) {
  color_bar(color = color, fun = normalize, ...)
}

#' Create a color-bar formatter using proportion
#'
#' @param color the background color of the bars
#' @param ... additional parameters passed to \code{proportion}
#' @export
#' @examples
#' formattable(mtcars, list(mpg = proportion_bar()))
#' @seealso
#' \link{color_bar}, \link{proportion}
proportion_bar <- function(color = "lightgray", ...) {
  color_bar(color = color, fun = proportion, ...)
}

#' Create a color-text formatter
#'
#' @param ... parameters passed to \code{gradient}.
#' @export
#' @examples
#' formattable(mtcars, list(mpg = color_text("black", "red")))
color_text <- function(...) {
  formatter("span",
    style = function(x) style(
      color = csscolor(gradient(x, ...))))
}
