#' Generic function to create an htmlwidget
#'
#' This function is a generic function to create an \code{htmlwidget}
#' to allow HTML/JS from R in multiple contexts.
#'
#' @param x an object.
#' @param ... arguments to be passed to methods.
#' @export
#' @return a \code{htmlwidget} object
as.htmlwidget <- function(x, ...)
  UseMethod("as.htmlwidget")


#' Convert formattable to an htmlwidget
#'
#' formattable was originally designed to work in \code{rmarkdown} environments.
#' Conversion of a formattable to a htmlwidget will allow use in other contexts
#' such as console, RStudio Viewer, and Shiny.
#'
#' @param x a \code{formattable} object to convert
#' @param width a valid \code{CSS} width
#' @param height a valid \code{CSS} height
#' @param ... reserved for more parameters
#' @return a \code{htmlwidget} object
#'
#' @examples
#' \dontrun{
#' library(formattable)
#' # mtcars (mpg background in gradient: the higher, the redder)
#' as.htmlwidget(
#'   formattable(mtcars, list(mpg = formatter("span",
#'    style = x ~ style(display = "block",
#'    "border-radius" = "4px",
#'    "padding-right" = "4px",
#'    color = "white",
#'    "background-color" = rgb(x/max(x), 0, 0))))
#'   )
#' )
#'
#' # since an htmlwidget, composes well with other tags
#' library(htmltools)
#'
#' browsable(
#'   tagList(
#'     tags$div( class="jumbotron"
#'               ,tags$h1( class = "text-center"
#'                         ,tags$span(class = "glyphicon glyphicon-fire")
#'                         ,"experimental as.htmlwidget at work"
#'               )
#'     )
#'     ,tags$div( class = "row"
#'                ,tags$div( class = "col-sm-2"
#'                           ,tags$p(class="bg-primary", "Hi, I am formattable htmlwidget.")
#'                )
#'                ,tags$div( class = "col-sm-6"
#'                           ,as.htmlwidget( formattable( mtcars ) )
#'                )
#'     )
#'   )
#' )
#' }
#' @importFrom markdown markdownToHTML
#' @importFrom htmlwidgets createWidget
#' @export
as.htmlwidget.formattable <- function(x, width = "100%", height = NULL, ...) {
  if (!is.formattable(x)) stop("expect formattable to be a formattable", call. = FALSE)
  md <- format(x, format = list(format = "markdown"))
  html <- gsub(x = # change align to bootstrap class for align
    markdown::markdownToHTML(
      text = gsub(x = md,
        pattern = "\n", replacement = "", fixed = TRUE), #remove line breaks
        fragment.only = TRUE),
    pattern = 'th align="', replacement = 'th class="text-', fixed = TRUE)

  # forward options using x
  x <- list(html = html, md = md)

  # create widget
  htmlwidgets::createWidget("formattable_widget", x, width = width,
    height = height, package = "formattable")
}

#' @importFrom shiny bootstrapPage
#' @importFrom htmltools tags
formattable_widget_html <- function(name, package, id, style, class, width, height) {
  shiny::bootstrapPage(htmltools::tags$div(id = id, class = class, style = style,
    width = width, height = height))
}

#' Widget output function for use in Shiny
#' @param outputId output variable to read from
#' @param width a valid \code{CSS} width or a number
#' @param height valid \code{CSS} height or a number
#' @importFrom htmlwidgets shinyWidgetOutput
#' @export
formattableOutput <- function(outputId, width = "100%", height = "0") {
  htmlwidgets::shinyWidgetOutput(outputId, "formattable_widget", width, height, package = "formattable")
}

#' Widget render function for use in Shiny
#' @param expr an expression that generates a valid \code{formattable} object
#' @param env the environment in which to evaluate expr.
#' @param quoted is expr a quoted expression (with quote())?
#' This is useful if you want to save an expression in a variable.
#' @importFrom htmlwidgets shinyRenderWidget
#' @export
renderFormattable <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(formattable::as.htmlwidget(expr)) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, formattableOutput, env, quoted = TRUE)
}
