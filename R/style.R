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
    paste(gsub(".", "-", names(args), fixed = TRUE), args, sep = ": ", collapse = "; ")
  }, dots, NULL))
}

#' Create icon-text elements
#' @param icon a character vector or list of character vectors
#' of icon names.
#' @param text a character vector of contents.
#' @param simplify logical to indicating whether to return
#' the only element if a single-valued list is resulted.
#' @param ... additional parameters (reserved)
#' @param provider the provider of icon set.
#' @param class_template a character value to specifiy to template of the class
#' with \code{"{provider}"} to represent \code{provider} value and \code{"{icon}"} to
#' represent \code{icon} values.
#' @seealso \href{http://getbootstrap.com/components/#glyphicons}{Glyphicons in Bootstrap},
#' \href{http://glyphicons.com/}{Glyphicons}
#' @export
#' @examples
#' icontext("plus")
#' icontext(c("star","star-empty"))
#' icontext(ifelse(mtcars$mpg > mean(mtcars$mpg), "plus", "minus"), mtcars$mpg)
#' icontext(list(rep("star",3), rep("star",2)), c("item 1", "item 2"))
icontext <- function(icon, text = list(NULL), ..., simplify = TRUE,
  provider = getOption("formattable.icon.provider", "glyphicon"),
  class_template = getOption("formattable.icon.class_template", "{provider} {provider}-{icon}")) {
  class_template <- gsub("{provider}", provider, class_template, fixed = TRUE)
  x <- .mapply(function(icon, text) {
    htmltools::tagList(
      lapply(icon, function(ico)
        htmltools::tag("i",
          list(class = gsub("{icon}", ico, class_template, fixed = TRUE)))), text)
  }, list(icon, text), NULL)
  if(length(x) == 1L) x[[1L]] else x
}

check_rgb <- function(x, alpha = TRUE) {
  grepl(if(alpha) "^#([0-9a-fA-F]{2}){3,4}$" else "^#([0-9a-fA-F]{2}){3}$", x)
}

check_rgba <- function(x) {
  grepl("^#([0-9a-fA-F]{2}){4}$", x)
}

str2rgb <- function(x, alpha = NULL) {
  is_rgb <- check_rgb(x)
  if(missing(alpha) || is.null(alpha)) alpha <- any(check_rgba(x))
  rownames <- c("red", "green", "blue", if(alpha) "alpha", NULL)
  rows <- length(rownames)
  res <- matrix(0L, rows, length(x), byrow = TRUE,
    dimnames = list(rownames, names(x)))
  rgbs <- x[is_rgb]
  res[, is_rgb] <- matrix(strtoi(c(
    substr(rgbs, 2L, 3L),
    substr(rgbs, 4L, 5L),
    substr(rgbs, 6L, 7L),
    if(alpha) ifelse(nzchar(alphav <- substr(rgbs, 8L, 9L)), alphav, "FF") else NULL), 16L),
    nrow = rows, byrow = TRUE)
  res[, !is_rgb] <- col2rgb(x[!is_rgb], alpha = alpha)
  res
}

#' Create a matrix from vector to represent colors in gradient
#' @param x a numeric vector.
#' @param min_color color of minimum value.
#' @param max_color color of maximum value.
#' @param alpha logical of whether to include alpha channel. \code{NULL}
#' to let the function decide by input.
#' @param use.names logical of whether to preserve names of input vector.
#' @return a matrix with rgba columns in which each row corresponds to the rgba
#' value (0-255) of each element in input vector \code{x}. Use \code{csscolor}
#' to convert the matrix to css color strings compatible with web browsers.
#' @seealso \code{\link{csscolor}}
#' @export
#' @examples
#' gradient(c(1,2,3,4,5), "white", "red")
#' gradient(c(5,4,3,2,1), "white", "red")
#' gradient(c(1,3,2,4,5), "white", "red")
#' gradient(c(1,3,2,4,5), rgb(0,0,0,0.5), rgb(0,0,0,1), alpha = TRUE)
gradient <- function(x, min_color, max_color, alpha = NULL, use.names = TRUE) {
  color_range <- str2rgb(c(min = min_color, max = max_color), alpha = alpha)
  res <- (color_range[, "max", drop = FALSE] -
      color_range[, "min", drop = FALSE]) %*% normalize(x) +
    matrix(rep(color_range[, "min", drop = FALSE], length(x)), ncol = length(x))
  storage.mode(res) <- "integer"
  if(use.names) colnames(res) <- names(x)
  res
}

#' Generate CSS-compatible color strings
#' @param x color input
#' @param format the output format of color strings
#' @param use.names logical of whether to preserve the names of input
#' @return a character vector of CSS-compatible color strings
#' @export
#' @examples
#' csscolor(rgb(0, 0.5, 0.5))
#' csscolor(c(rgb(0, 0.2, 0.2), rgb(0, 0.5, 0.2)))
#' csscolor(rgb(0, 0.5, 0.5, 0.2))
#' csscolor(gradient(c(1,2,3,4,5), "white", "red"))
csscolor <- function(x, format = c("auto", "hex", "rgb", "rgba"),
  use.names = TRUE)
  UseMethod("csscolor")

#' @export
csscolor.character <- function(x, format = c("auto", "hex", "rgb", "rgba"), use.names = TRUE) {
  format <- match.arg(format)
  alpha <- all(check_rgb(x)) && any(check_rgba(x))
  if(format == "auto") format <- if(alpha) "rgba" else "hex"
  switch(format, hex = x,
    csscolor.matrix(str2rgb(x, alpha = alpha), format = format, use.names = use.names))
}

#' @export
csscolor.matrix <- function(x, format = c("auto", "hex", "rgb", "rgba"), use.names = TRUE) {
  format <- match.arg(format)
  alpha <- "alpha" %in% rownames(x)
  if(format == "auto") format <- if(alpha) "rgba" else "hex"
  cols <- switch(format, hex = {
    hex <- format.hexmode(as.hexmode(x[c("red", "green", "blue"), ]), width = 2L)
    paste0("#", hex[1L, ], hex[2L, ], hex[3L, ])
  }, rgb = paste0("rgb(", x["red", ], ", ", x["green", ], ", ", x["blue", ], ")"),
    rgba = paste0("rgba(", x["red", ], ", ", x["green", ], ", ", x["blue", ], ", ",
      if(alpha) round(x["alpha", ] / 255, 2) else 1, ")"))
  if(use.names) names(cols) <- colnames(x)
  cols
}