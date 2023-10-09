#' Vectorized map from element to case by index or string value
#'
#' This function is a vectorized version of [switch()], that is, for
#' each element of input vector, [switch()] is evaluated and the results are
#' combined.
#'
#' @param EXPR an expression evaluated to be character or numeric vector/list.
#' @param ... The list of alternatives for each [switch()].
#' @param SIMPLIFY `TRUE` to simplify the resulted list to vector, matrix
#' or array if possible.
#' @seealso [switch()]
#' @export
#' @examples
#' x <- c("normal","normal","error","unknown","unknown")
#' vmap(x, normal = 0, error = -1, unknown = -2)
#'
#' x <- c(1,1,2,1,2,2,1,1,2)
#' vmap(x, "type-A", "type-B")
vmap <- function(EXPR, ..., SIMPLIFY = TRUE) {
  if (is.factor(EXPR)) EXPR <- as.character.factor(EXPR)
  res <- lapply(EXPR, switch, ...)
  if (SIMPLIFY) simplify2array(res) else res
}

#' Quantile ranks of a vector
#'
#' The quantile rank of a number in a vector is the relative
#' position of ranking resulted from rank divided by the length
#' of vector.
#' @param x a vector
#' @param ... additional parameters passed to [rank()]
#' @seealso [rank()]
#' @export
#' @examples
#' qrank(mtcars$mpg)
qrank <- function(x, ...) {
  rank(x = x, ...) / length(x)
}

#' Normalize a vector to fit zero-to-one scale
#'
#' @param x a numeric vector
#' @param min numeric value. The lower bound of the interval to normalize `x`.
#' @param max numeric value. The upper bound of the interval to normalize `x`.
#' @param na.rm a logical indicating whether missing values should be removed
#' @export
#' @examples
#' normalize(mtcars$mpg)
normalize <- function(x, min = 0, max = 1, na.rm = FALSE) {
  if (all(is.na(x))) return(rep(0, length(x)))
  if (!is.numeric(x)) stop("x must be numeric")
  x <- unclass(x)
  if (min > max) stop("min <= max must be satisfied")
  if (all(x == 0, na.rm = na.rm)) return(x)
  xmax <- max(x, na.rm = na.rm)
  xmin <- min(x, na.rm = na.rm)
  if (xmax == xmin) return(rep(1, length(x)))
  min + (max - min) * (x - xmin) / (xmax - xmin)
}

#' Rescale a vector relative to the maximal absolute value in the vector
#'
#' @param x a numeric vector
#' @param na.rm a logical indicating whether missing values should be removed
#' @export
#' @examplesIf requireNamespace("htmlwidgets", quietly = TRUE)
#' proportion(mtcars$mpg)
proportion <- function(x, na.rm = FALSE) {
  x / max(abs(x), na.rm = na.rm)
}
