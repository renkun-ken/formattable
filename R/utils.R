base_ifelse <- getExportedValue("base", "ifelse")

as_numeric <- function(x) if (is.numeric(x)) x else as.numeric(x)

set_class <- function(x, class) {
  class(x) <- unique(c(class, class(x)))
  x
}

get_class_attribute <- function(x, class, attributes = NULL) {
  base_class <- class[[length(class)]]
  attr(x, base_class, exact = TRUE)
}

set_class_attribute <- function(x, class, attributes = NULL) {
  base_class <- class[[length(class)]]
  if (!is.null(attributes)) {
    attr(x, base_class) <- attributes
  }
  x
}

create_obj <- function(x, class, attributes = NULL) {
  x <- set_class_attribute(x, class, attributes)
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
  class(x) <- setdiff(class(x), class)
  x
}

remove_attribute <- function(x, which) {
  attr(x, which) <- NULL
  x
}

copy_obj <- function(src, target, class) {
  create_obj(target, class, get_class_attribute(src, class))
}

fcreate_obj <- function(f, class, x, ...) {
  class_out <- class(x)
  create_obj(f(remove_class(x, class_out), ...), class_out, get_class_attribute(x, class))
}

cop_create_obj <- function(op, class, x, y) {
  if (inherits(x, class)) {
    class_out <- class(x)
    if (missing(y)) {
      create_obj(
        op(remove_class(x, class_out)),
        class_out,
        get_class_attribute(x, class)
      )
    }
    else {
      create_obj(
        op(remove_class(x, class_out), unclass(y)),
        class_out,
        get_class_attribute(x, class)
      )
    }
  } else if (inherits(y, class)) {
    class_out <- class(y)
    create_obj(
      op(unclass(x), remove_class(y, class_out)),
      class_out,
      get_class_attribute(y, class)
    )
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

get_false_entries <- function(x) {
  y <- vapply(x, is_false, logical(1L))
  y <- names(x)[y]
  y[nzchar(y)]
}

is_false <- function(x) {
  is.logical(x) && length(x) == 1L && x == FALSE
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
