#' The formattable package
#'
#' This package is designed for applying formatting on data frames to be
#' presented on web pages rendered from RMarkdown documents.
#'
#' @name formattable-package
#' @docType package
#' @details
#' In a typical workflow of dynamic document production, \code{knitr} and
#' \code{rmarkdown} are powerful tools to render documents with R code to different
#' types of portable documents.
#'
#' \code{knitr} package is able to render a RMarkdown document (markdown document
#' with R code chunks) to Markdown document. \code{rmarkdown} calls \code{pandoc}
#' to render markdown document to HTML web page. To put a table from a \code{data.frame}
#' on the page, one may call \code{knitr::kable} to produce its markdown
#' representation. By default the resulted table is in a plain theme with no
#' additional formatting. However, in some cases, additional formatting
#' may help clarify the information and make contrast of the data.
NULL