test_that("percent", {
  expect_identical(format(percent(numeric())), character())

  data <- c(-0.05, 0.15, 0.252, 0.3003)
  obj <- percent(data)
  expect_s3_class(obj, c("formattable", "numeric"))
  expect_equal(format(obj), c("-5.00%", "15.00%", "25.20%", "30.03%"))
  expect_equal(format(percent(data, digits = 0)), c("-5%", "15%", "25%", "30%"))
  expect_equal(format(percent(obj, digits = 0)), c("-5%", "15%", "25%", "30%"))
  expect_warning(percent("a"), regexp = "NA")
  expect_equal(percent("1.00%"), percent(0.01))
  expect_equal(percent("1%"), percent(0.01, digits = 0L))
  expect_equal(percent(c("1.00%", "1%")), percent(c(0.01, 0.01)))
  expect_equal(percent(c("1.00%", "1.5")), percent(c(0.01, 1.5)))
  expect_s3_class(percent(NA), "numeric")

  # percent matrix
  dim(data) <- c(2, 2)
  obj <- percent(data)
  expect_s3_class(obj, c("formattable", "matrix"))
  expect_equal(format(obj), matrix(c("-5.00%", "15.00%", "25.20%", "30.03%"), 2))

  # parse percent from matrix
  x <- matrix(c("0.5%", "1.5%", "10.2%", "3.8%"), 2,
    dimnames = list(c("a", "b"), c("c", "d"))
  )
  obj <- percent(x)
  expect_s3_class(obj, c("formattable", "matrix"))
  expect_equal(length(dim(format(obj))), 2)
  expect_equal(as.numeric(gsub("%", "", x, fixed = TRUE)) / 100, as.numeric(obj))
})
