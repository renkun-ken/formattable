% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/package.R
\docType{package}
\name{formattable-package}
\alias{formattable-package}
\title{The formattable package}
\description{
This package is designed for applying formatting on vectors and
data frames to make data presentation easier, richer, more flexible
and hopefully convey more information.
}
\details{
Atomic vectors are basic units to store data. Some data can be read more easily
with formatting. A numeric vector, for example, stores a group of
percentage numbers yet still shows in the form of typical floating numbers. This
package provides functions to create data structures with predefined
formatting rules so that these objects stores the original data but are printed
with formatting.

On the other hand, in a typical workflow of dynamic document production, \code{knitr}
and \code{rmarkdown} are powerful tools to render documents with R code to different
types of portable documents.

\code{knitr} package is able to render a RMarkdown document (markdown document
with R code chunks to be executed sequentially) to Markdown document.
\code{rmarkdown} calls \code{pandoc} to render markdown document to HTML web page.
To put a table from a \code{data.frame} on the page, one may call \code{\link[knitr:kable]{knitr::kable()}}
to produce its markdown representation. By default the resulted table is in a plain
theme with no additional formatting. However, in some cases, additional formatting
may help clarify the information and make contrast of the data.
}
\seealso{
Useful links:
\itemize{
  \item \url{https://renkun-ken.github.io/formattable/}
  \item \url{https://github.com/renkun-ken/formattable}
  \item Report bugs at \url{https://github.com/renkun-ken/formattable/issues}
}

}
\author{
\strong{Maintainer}: Kun Ren \email{ken@renkun.me}

Authors:
\itemize{
  \item Kenton Russell \email{kent.russell@timelyportfolio.com}
}

}
