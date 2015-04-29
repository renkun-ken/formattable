create_obj <- function(x, class, attributes = list()) {
  attr(x, class) <- attributes
  if (!(class %in% (cls <- class(x))))
    class(x) <- c(class, cls)
  x
}

remove_class <- function(x, class) {
  cls <- class(x)
  class(x) <- cls[!(cls %in% class)]
  x
}

remove_attribute <- function(x, which) {
  attr(x, which) <- NULL
  x
}

copy_obj <- function(src, target, class) {
  create_obj(target, class, get_attr(src, class))
}

attr_default <- function(x, class, default = NULL) {
  if (is.null(value <- attr(x, class, exact = TRUE))) default else value
}

get_attr <- function(x, class) {
  if (is.null(value <- attr(x, class, exact = TRUE)))
    stop("missing attribute for class '", class, "'.", call. = FALSE) else
      value
}

call_or_default <- function(FUN, X, ...) {
  if (is.null(FUN)) X else match.fun(FUN)(X, ...)
}

eval_formula <- function(x, data, envir) {
  if(!is.symbol(symbol <- x[[2L]])) {
    stop("The formula should specify a symbol", call. = FALSE)
  }
  eval_args <- list(data)
  names(eval_args) <- as.character(symbol)
  eval(x[[3L]], eval_args, envir)
}
