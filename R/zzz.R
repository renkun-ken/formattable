# nocov start

.onLoad <- function(libname, pkgname) {
  s3_register("knitr::knit_print", "formattable")
}

# nocov end
