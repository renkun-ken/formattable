#' Formattable object with prefix
#' @param x an object
#' @param prefix a character vector put in front of each non-missing
#' value in `x` as being formatted.
#' @param sep separator
#' @param ... additional parameter passed to [formattable()].
#' @param na.text text for missing values in `x`.
#' @export
#' @examples
#' prefix(1:10, "A")
#' prefix(1:10, "Choice", sep = " ")
#' prefix(c(1:10, NA), prefix = "A", na.text = "(missing)")
#' prefix(rnorm(10, 10), "*", format = "d")
#' prefix(percent(c(0.1, 0.25)), ">")
prefix <- function(x, prefix = "", sep = "", ..., na.text = NULL) {
  formattable(x, ...,
    postproc = list(function(str, x) {
      paste0(
        ifelse(xna <- is.na(x), "", paste0(prefix, sep)),
        if (is.null(na.text)) str else ifelse(xna, na.text, str)
      )
    })
  )
}
