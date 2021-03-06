% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/num_scientific.R
\name{num_scientific}
\alias{num_scientific}
\title{Numeric vector with scientific format}
\usage{
num_scientific(x, format = c("e", "E"), ...)
}
\arguments{
\item{x}{a numeric vector.}

\item{format}{format type passed to \code{\link[=formatC]{formatC()}}.}

\item{...}{additional parameter passed to \code{\link[=formattable]{formattable()}}.}
}
\description{
Formats numbers in scientific format.
}
\examples{
num_scientific(1250000)
num_scientific(1253421, digits = 8)
num_scientific(1253421, digits = 8, format = "E")
}
\seealso{
Other numeric vectors: 
\code{\link{num_accounting}()},
\code{\link{num_comma}()},
\code{\link{num_currency}()},
\code{\link{num_digits}()},
\code{\link{num_percent}()}
}
\concept{numeric vectors}
