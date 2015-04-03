#' @export
formatter <- function(tag, ...) {
  args <- list(...)

  # if function to specify element inner text is missing,
  # then use identify to preserve the default formatting of
  # the column value
  if(all(nzchar(names(args)))) {
    args <- c(args, identity)
  }

  # create a closure for formattable to build output string
  function(x) {
    values <- lapply(args, function(arg) {
      if(is.function(arg)) arg(x) else arg
    })
    tags <- .mapply(function(...) {
      attrs <- list(...)
      htmltools::tag(tag, attrs[!is.na(attrs)])
    }, values, NULL)
    vapply(tags, as.character, character(1L))
  }
}
