#' @export
formatter <- function(tag, ...) {
  args <- list(...)

  # if function to specify element inner text is missing,
  # then use identify to preserve the default text of
  # the column value
  if(length(args) == 0L || (!is.null(argnames <- names(args)) && all(nzchar(argnames)))) {
    args <- c(args, identity)
  }

  # create a closure for formattable to build output string
  function(x) {
    values <- lapply(args, function(arg) {
      if(is.function(arg)) arg(x) else arg
    })
    null_values <- vapply(values, is.null, logical(1L))
    values[null_values] <- NA
    tags <- .mapply(function(...) {
      attrs <- list(...)
      nulls <- vapply(attrs, is.null, logical(1L))
      htmltools::tag(tag, attrs[!nulls & !is.na(attrs)])
    }, values, NULL)
    vapply(tags, as.character, character(1L))
  }
}
