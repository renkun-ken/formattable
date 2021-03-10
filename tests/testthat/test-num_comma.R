test_that("comma", {
  expect_identical(format(comma(numeric())), character())

  data <- c(-5300, 10500, 20300, 35010)
  obj <- comma(data)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj), c("-5,300.00", "10,500.00", "20,300.00", "35,010.00"))
  expect_equal(format(comma(data, digits = 0)), c("-5,300", "10,500", "20,300", "35,010"))
  expect_equal(
    format(comma(obj, digits = 0, big.mark = "/")),
    c("-5/300", "10/500", "20/300", "35/010")
  )
  expect_warning(comma("a"))
  expect_equal(comma("123,234.56"), comma(123234.56))
  expect_equal(comma(c("1.23", "1,233.1232")), comma(c(1.23, 1233.1232), digits = 4))
  expect_is(comma(NA), "numeric")
})
