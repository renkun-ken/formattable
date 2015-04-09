eval_formula <- function(x, data, envir) {
  if(!is.symbol(symbol <- x[[2L]])) {
    stop("The formula should specify a symbol", call. = FALSE)
  }
  eval_args <- list(data)
  names(eval_args) <- as.character(symbol)
  eval(x[[3L]], eval_args, envir)
}
