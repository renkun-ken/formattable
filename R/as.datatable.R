#' Generic function to create an htmlwidget
#'
#' This function is a generic function to create an \code{htmlwidget}
#' to allow HTML/JS from R in multiple contexts.
#'
#' @param x an object.
#' @param ... arguments to be passed to \code{\link[DT]{datatable}}
#' @export
#' @return a \code{\link[DT]{datatable}} object
as.datatable <- function(x, ...) {
  UseMethod("as.datatable")
}

#' Convert \code{formattable} to a \code{\link[DT]{datatable}} htmlwidget
#'
#' @param x a \code{formattable} object to convert
#' @param escape \code{logical} to escape \code{HTML}. The default is
#'          \code{FALSE} since it is expected that \code{formatters} from
#'          \code{formattable} will produce \code{HTML} tags.
#' @param ... additional arguments passed to to \code{\link[DT]{datatable}}
#' @return a \code{\link[DT]{datatable}} object
#' @export
as.datatable.formattable <- function(x, escape = FALSE, ...) {
  stopifnot(is.formattable(x), requireNamespace("DT"))
  DT::datatable(
    render_html_matrix.formattable(x),
    escape = escape,
    ...
  )
}
