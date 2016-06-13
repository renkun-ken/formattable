base_ifelse <- getExportedValue("base", "ifelse")

as_numeric <- function(x) if (is.numeric(x)) x else as.numeric(x)

set_class <- function(x, class) {
  if (!inherits(x, class))
    class(x) <- c(class, class(x))
  x
}

create_obj <- function(x, class, attributes) {
  if (!missing(attributes)) attr(x, class) <- attributes
  set_class(x, class)
}

reset_class <- function(src, target, class) {
  if (storage.mode(target) == storage.mode(src)) target
  else set_class(unclass(target), class)
}

ifelse <- function(test, yes, no, ...) {
  base_ifelse(test, yes, no)
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
  create_obj(target, class, attr(src, class, exact = TRUE))
}

fcreate_obj <- function(f, class, x, ...) {
  create_obj(f(remove_class(x, class), ...), class, attr(x, class, exact = TRUE))
}

cop_create_obj <- function(op, class, x, y) {
  if (inherits(x, class)) {
    if (missing(y))
      create_obj(op(remove_class(x, class)), class, attr(x, class, exact = TRUE))
    else
      create_obj(op(remove_class(x, class), unclass(y)), class, attr(x, class, exact = TRUE))
  } else if (inherits(y, class)) {
    create_obj(op(unclass(x), remove_class(y, class)), class, attr(y, class, exact = TRUE))
  } else {
    create_obj(op(x, y), class, NULL)
  }
}

call_or_default <- function(FUN, X, ...) {
  if (is.null(FUN)) X else match.fun(FUN)(X, ...)
}

eval_formula <- function(x, var, data, envir = environment(x)) {
  if (length(x) == 2L) {
    eval(x[[2L]], if (!missing(data) && is.list(data)) data else NULL, envir)
  } else if (is.symbol(symbol <- x[[2L]])) {
    eval_args <- list(var)
    names(eval_args) <- as.character(symbol)
    eval(x[[3L]], eval_args, envir)
  } else {
    stop("The formula should be either '~ expr' or 'x ~ expr'", call. = FALSE)
  }
}

get_digits <- function(x) {
  ifelse(grepl(".", x, fixed = TRUE),
    nchar(gsub("^.*\\.([0-9]*).*$", "\\1", x)), 0L)
}

seq_list <- function(x = character()) {
  lst <- as.list(seq_along(x))
  names(lst) <- x
  lst
}

copy_dim <- function(src, target, use.names = TRUE) {
  if (is.array(src)) {
    dim(target) <- dim(src)
    if (use.names) dimnames(target) <- dimnames(src)
  } else {
    if (use.names) names(target) <- names(src)
  }
  target
}
