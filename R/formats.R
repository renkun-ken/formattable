#' Formattable object with suffix
#' @param x an object
#' @param suffix a character vector put behind each non-missing
#' value in \code{x} as being formatted.
#' @param sep separator
#' @param ... additional parameter passed to \code{formattable}.
#' @param na.text text for missing values in \code{x}.
#' @export
#' @examples
#' suffix(1:10, "px")
#' suffix(1:10, ifelse(1:10 >= 2, "units", "unit"), sep = " ")
#' suffix(c(1:10, NA), "km/h", na.text = "(missing)")
#' suffix(percent(c(0.1, 0.25)), "*")
suffix <- function(x, suffix = "", sep = "", ..., na.text = NULL) {
  formattable(x, ...,
    postproc = list(function(str, x) {
      xna <- is.na(x)
      paste0(if (is.null(na.text)) str else ifelse(xna, na.text, str),
        ifelse(xna, "", paste0(sep, suffix)))
    }))
}
