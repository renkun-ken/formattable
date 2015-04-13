#' Create a string-representation of CSS style
#'
#' Most HTML elements can be stylized by a set of CSS style
#' properties. This function helps build CSS strings using
#' conventional argument-passing in R.
#'
#' @details
#' The general usage of CSS styling is
#'
#' \code{<span style = "color: red; border: 1px">Text</span>}
#'
#' The text color can be specified by `color`, the border of
#' element by `border`, and etc.
#'
#' Basic styles like \code{color}, \code{border}, \code{background}
#' work properly and mostly consistently in modern web browsers.
#' However, some style properties may not work consistently in
#' different browsers.
#' @param ... style attributes in form of \code{name = value}. Many CSS properties
#' contains \code{'-'} in the middle of their names. In this case, use
#' \code{"the-name" = value} instead. \code{NA} will cancel the attribute.
#' @return a string-representation of css styles
#' @examples
#' style(color = "red")
#' style(color = "red", "font-weight" = "bold")
#' style("background-color" = "gray", "border-radius" = "4px")
#' style("padding-right" = "2px")
#'
#' formattable(mtcars, list(
#'   mpg = formatter("span",
#'     style = x ~ style(color = ifelse(x > median(x), "red", NA)))))
#' @seealso \href{http://www.w3.org/Style/CSS/all-properties}{List of CSS properties},
#'   \href{http://www.w3schools.com/cssref/}{CSS Reference}
#' @export
style <- function(...) {
  dots <- list(...)
  as.character(.mapply(function(...) {
    args <- list(...)
    args <- args[!is.na(args)]
    paste(names(args), args, sep = ": ", collapse = "; ")
  }, dots, NULL))
}

# style helpers
