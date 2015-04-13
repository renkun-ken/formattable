#' Multi-input switch
#'
#' This function is a vectorized version of \code{base::switch}, that is, for
#' each element of input vector, \code{switch} is evaluated and the results are
#' combined.
#'
#' @param EXPR an expression evaluated to be character or numeric vector.
#' @param ... The list of alternatives for each \code{switch}.
#' @param SIMPLIFY \code{TRUE} to simplify the resulted list to vector, matrix
#' or array if possible.
#' @seealso \code{\link{switch}}
#' @export
#' @examples
#' x <- c("normal","normal","error","unknown","unknown")
#' switches(x, normal = 0, error = -1, unknown = -2)
#'
#' x <- c(1,1,2,1,2,2,1,1,2)
#' switches(x, "type-A", "type-B")
switches <- function(EXPR, ..., SIMPLIFY = TRUE) {
  res <- lapply(EXPR, function(i) switch(i, ...))
  if(SIMPLIFY) simplify2array(res) else res
}
