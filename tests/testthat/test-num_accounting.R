test_that("accounting", {
  expect_identical(format(accounting(numeric())), character())

  data <- c(-5300, 10500, 20300, 35010)
  obj <- accounting(data)
  expect_s3_class(obj, c("formattable", "numeric"))
  expect_equal(format(obj), c("(5,300.00)", "10,500.00", "20,300.00", "35,010.00"))
  expect_equal(format(accounting(data, digits = 0)), c("(5,300)", "10,500", "20,300", "35,010"))
  expect_equal(
    format(accounting(obj, digits = 0, big.mark = "/")),
    c("(5/300)", "10/500", "20/300", "35/010")
  )
  expect_warning(accounting("a"))
  expect_equal(
    accounting(c("123,23.50", "(123.243)")),
    accounting(c(12323.5, -123.243), digits = 3)
  )
  expect_s3_class(accounting(NA), "numeric")
})
