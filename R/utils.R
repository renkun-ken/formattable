create_obj <- function(x, class, attributes = list(), reset = FALSE) {
  if (reset) attributes(x) <- attributes else
    attributes(x)[names(attributes)] <- attributes
  if (!(class %in% (cls <- class(x))))
    class(x) <- c(class, cls)
  x
}

remove_class <- function(x, class) {
  cls <- class(x)
  class(x) <- cls[!(cls %in% class)]
  x
}

remove_attributes <- function(x) {
  attributes(x) <- NULL
  x
}

attr_default <- function(..., default = NULL) {
  if (is.null(value <- attr(...))) default else value
}

call_or_default <- function(FUN, X, ...) {
  if (is.null(FUN)) X else match.fun(FUN)(X, ...)
}

formattable_attributes <- function(x, fields = c("formatter", "format", "preproc", "postproc")) {
  attributes(x)[fields]
}

eval_formula <- function(x, data, envir) {
  if(!is.symbol(symbol <- x[[2L]])) {
    stop("The formula should specify a symbol", call. = FALSE)
  }
  eval_args <- list(data)
  names(eval_args) <- as.character(symbol)
  eval(x[[3L]], eval_args, envir)
}
