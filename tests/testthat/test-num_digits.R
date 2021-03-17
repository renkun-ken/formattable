test_that("digits", {
  expect_identical(format(digits(numeric(), 1)), character())

  data <- c(pi, 123, 12.3456)
  obj <- digits(data, 1)
  expect_s3_class(obj, c("formattable", "numeric"))
  expect_equal(format(obj), formatC(data, format = "f", digits = 1))
  expect_equal(format(digits(data, 2)), formatC(data, format = "f", digits = 2))
  expect_s3_class(digits(NA, 2), "numeric")
})
