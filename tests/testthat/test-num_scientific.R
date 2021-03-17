test_that("scientific", {
  expect_identical(format(scientific(numeric())), character())

  data <- c(-5300, 10500, 20300, 35010)
  obj <- scientific(data)
  expect_s3_class(obj, c("formattable", "numeric"))
  expect_equal(
    format(scientific(data, format = "e", digits = 2)),
    c("-5.30e+03", "1.05e+04", "2.03e+04", "3.50e+04")
  )
  expect_equal(
    format(scientific(data, format = "E", digits = 2)),
    c("-5.30E+03", "1.05E+04", "2.03E+04", "3.50E+04")
  )
  expect_warning(scientific("a"), "NA")
  expect_s3_class(scientific(NA), "numeric")
})
