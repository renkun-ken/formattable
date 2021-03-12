#' Generic function to create an htmlwidget
#'
#' This function is a generic function to create an `htmlwidget`
#' to allow HTML/JS from R in multiple contexts.
#'
#' @param x an object.
#' @param ... arguments to be passed to [DT::datatable()]
#' @export
#' @return a [DT::datatable()] object
as.datatable <- function(x, ...) {
  UseMethod("as.datatable")
}

#' Convert `formattable` to a [DT::datatable()] htmlwidget
#'
#' @param x a `formattable` object to convert
#' @param escape `logical` to escape `HTML`. The default is
#'          `FALSE` since it is expected that `formatters` from
#'          `formattable` will produce `HTML` tags.
#' @param ... additional arguments passed to to [DT::datatable()]
#' @return a [DT::datatable()] object
#' @export
as.datatable.formattable <- function(x, escape = FALSE, ...) {
  stopifnot(is.formattable(x), requireNamespace("DT"))
  DT::datatable(
    render_html_matrix.formattable(x),
    escape = escape,
    ...
  )
}
