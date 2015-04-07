#' @export
formatter <- function(tag, ...) {
  args <- list(...)
  envir <- parent.frame()
  # if function to specify element inner text is missing,
  # then use identify to preserve the default text of
  # the column value
  if(length(args) == 0L || (!is.null(argnames <- names(args)) && all(nzchar(argnames)))) {
    args <- c(args, identity)
  }

  # create a closure for formattable to build output string
  function(x) {
    values <- lapply(args, function(arg) {
      value <- if(is.function(arg)) {
        arg(x)
      } else if(inherits(arg, "formula")) {
        if(!is.symbol(symbol <- arg[[2L]])) {
          stop("The formula should specify a symbol", call. = FALSE)
        }
        eval_args <- list(x)
        names(eval_args) <- as.character(arg[[2L]])
        eval(arg[[3L]], eval_args, envir)
      } else arg
      if(is.null(value)) NA else value
    })
    tags <- .mapply(function(...) {
      attrs <- list(...)
      htmltools::tag(tag, attrs[!is.na(attrs) & nzchar(attrs)])
    }, values, NULL)
    vapply(tags, as.character, character(1L))
  }
}
