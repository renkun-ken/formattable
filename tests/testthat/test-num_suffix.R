test_that("suffix", {
  expect_identical(format(suffix(numeric())), character())

  data <- 1:10
  obj <- suffix(data)
  expect_s3_class(obj, c("formattable", "integer"))
  expect_equal(format(suffix(data, "px")), paste0(data, "px"))
  expect_equal(
    format(suffix(c(data, NA), "km/h", sep = " ", na.text = "missing")),
    c(paste(data, "km/h"), "missing")
  )

  data <- rnorm(10)
  expect_equal(
    format(suffix(data, "?", format = "f", digits = 2L)),
    paste0(formatC(data, format = "f", digits = 2L), "?")
  )
  expect_equal(
    format(suffix(percent(data), ">")),
    paste0(format(percent(data)), ">")
  )
  expect_equal(
    format(suffix(percent(data), ">") + 0.1),
    paste0(format(percent(data) + 0.1), ">")
  )
})
