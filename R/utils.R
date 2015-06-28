set_class <- function(x, class) {
  if (!inherits(x, class))
    class(x) <- c(class, class(x))
  x
}

create_obj <- function(x, class, attributes) {
  if (!missing(attributes)) attr(x, class) <- attributes
  set_class(x, class)
}

ifelse <- function(test, yes, no, ...) {
  base::ifelse(test, yes, no)
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

eval_formula <- function(x, data, envir = environment(x)) {
  if (length(x) == 2L) {
    eval(x[[2L]], NULL, envir)
  } else if (is.symbol(symbol <- x[[2L]])) {
    eval_args <- list(data)
    names(eval_args) <- as.character(symbol)
    eval(x[[3L]], eval_args, envir)
  } else {
    stop("The formula should be either '~ expr' or 'x ~ expr'", call. = FALSE)
  }
}

get_digits <- function(x) {
  has_decimal_point <- grepl(".", x, fixed = TRUE)
  valid <- grepl("([0-9]+)|([0-9]*\\.[0-9]*)", x)
  decimals <- gsub("[0-9]*\\.([0-9]*).*$", "\\1", x)
  digits <- nchar(decimals)
  digits[!valid] <- NA_integer_
  digits[valid & !has_decimal_point] <- 0L
  digits
}
