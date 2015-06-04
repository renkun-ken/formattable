#' Convert formattable to an htmlwidget
#'
#' formattable was originally designed to work in \code{rmarkdown} environments.
#' Conversion of a formattable to a htmlwidget will allow use in other contexts
#' such as console, RStudio Viewer, and Shiny.
#'
#'
#' @examples
#' \dontrun{
#' library(formattable)
#' # mtcars (mpg background in gradient: the higher, the redder)
#' as_htmlwidget(
#'   formattable(mtcars, list(mpg = formatter("span",
#'    style = x ~ style(display = "block",
#'    "border-radius" = "4px",
#'    "padding-right" = "4px",
#'    color = "white",
#'    "background-color" = rgb(x/max(x), 0, 0))))
#'   )
#' )
#' }
#' @import htmlwidgets markdown
#'
#' @export
#'
as_htmlwidget <- function(formattable = NULL, width = NULL, height = NULL) {

  if(!inherits(formattable,"formattable")) stop( "expect formattable to be a formattable", call. = F)

  html = markdown::markdownToHTML(
    text = gsub(
      x = as.character(formattable)
      , pattern = "\n"
      , replacement = ""
    )
    , fragment.only = T
  )

  md = as.character(formattable)

  # forward options using x
  x = list(
    html = html
    , md = md
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'formattable_widget',
    x,
    width = width,
    height = height,
    package = 'formattable'
  )
}


#' @importFrom shiny bootstrapPage
formattable_widget_html <- function( name, package, id, style, class, width, height ){
  shiny:::bootstrapPage(
    htmltools::tags$div( id = id, class = class, style = style )
  )
}
