test_that("currency", {
  expect_identical(format(currency(numeric())), character())

  data <- c(-5300, 10500, 20300, 35010)
  obj <- currency(data)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj, symbol = "$"), c("$-5,300.00", "$10,500.00", "$20,300.00", "$35,010.00"))
  expect_equal(format(currency(data, symbol = "$", digits = 0)), c("$-5,300", "$10,500", "$20,300", "$35,010"))
  expect_equal(
    format(currency(obj, symbol = "$", digits = 0, big.mark = "/")),
    c("$-5/300", "$10/500", "$20/300", "$35/010")
  )
  expect_equal(format(currency(1000, "USD", digits = 0, sep = " ")), "USD 1,000")
  expect_equal(format(currency("$ 123,234.50", symbol = "$", sep = " ")), "$ 123,234.50")
  expect_warning(currency("a"))
  expect_equal(format(currency("$ 123,234.50")), format(currency(123234.50, symbol = "$", digits = 2)))
  expect_equal(
    format(currency(c("$ 123,234.50", "$123.503"), digits = 3)),
    format(currency(c(123234.500, 123.503), symbol = "$", digits = 3))
  )
  expect_equal(
    format(currency(c("HK$ 123,234.50", "HK$ 123.503"), symbol = "HK$", digits = 3)),
    format(currency(c(123234.500, 123.503), symbol = "HK$", digits = 3))
  )
  expect_equal(
    format(currency(c("HK$ 123,234.50", "HK$ 123.503"), digits = 3)),
    format(currency(c(123234.500, 123.503), symbol = "HK$", digits = 3))
  )
  expect_is(currency(NA), "numeric")
})
