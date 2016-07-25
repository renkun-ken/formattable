context("formats")

test_that("percent", {
  data <- c(-0.05, 0.15,0.252,0.3003)
  obj <- percent(data)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj), c("-5.00%","15.00%","25.20%","30.03%"))
  expect_equal(format(percent(data, digits = 0)), c("-5%","15%","25%","30%"))
  expect_equal(format(percent(obj, digits = 0)), c("-5%","15%","25%","30%"))
  expect_warning(percent("a"), regexp = "NA")
  expect_equal(percent("1.00%"), percent(0.01))
  expect_equal(percent("1%"), percent(0.01, digits = 0L))
  expect_equal(percent(c("1.00%", "1%")), percent(c(0.01, 0.01)))
  expect_equal(percent(c("1.00%", "1.5")), percent(c(0.01, 1.5)))
  expect_is(percent(NA), "numeric")

  # percent matrix
  dim(data) <- c(2, 2)
  obj <- percent(data)
  expect_is(obj, c("formattable", "matrix"))
  expect_equal(format(obj), matrix(c("-5.00%","15.00%","25.20%","30.03%"), 2))

  # parse percent from matrix
  x <- matrix(c("0.5%", "1.5%", "10.2%", "3.8%"), 2,
    dimnames = list(c("a", "b"), c("c", "d")))
  obj <- percent(x)
  expect_is(obj, c("formattable", "matrix"))
  expect_is(format(obj), "matrix")
  expect_equal(as.numeric(gsub("%", "", x, fixed = TRUE)) / 100, as.numeric(obj))
})

test_that("digits", {
  data <- c(pi, 123, 12.3456)
  obj <- digits(data, 1)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj), formatC(data, format = "f", digits = 1))
  expect_equal(format(digits(data, 2)), formatC(data, format = "f", digits = 2))
  expect_is(digits(NA, 2), "numeric")
})

test_that("comma", {
  data <- c(-5300,10500,20300,35010)
  obj <- comma(data)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj), c("-5,300.00","10,500.00","20,300.00","35,010.00"))
  expect_equal(format(comma(data, digits = 0)), c("-5,300","10,500","20,300","35,010"))
  expect_equal(format(comma(obj, digits = 0, big.mark = "/")),
    c("-5/300","10/500","20/300","35/010"))
  expect_warning(comma("a"))
  expect_equal(comma("123,234.56"), comma(123234.56))
  expect_equal(comma(c("1.23", "1,233.1232")), comma(c(1.23, 1233.1232), digits = 4))
  expect_is(comma(NA), "numeric")
})

test_that("currency", {
  data <- c(-5300,10500,20300,35010)
  obj <- currency(data)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj), c("$-5,300.00","$10,500.00","$20,300.00","$35,010.00"))
  expect_equal(format(currency(data, digits = 0)), c("$-5,300","$10,500","$20,300","$35,010"))
  expect_equal(format(currency(obj, digits = 0, big.mark = "/")),
    c("$-5/300","$10/500","$20/300","$35/010"))
  expect_equal(format(currency(1000, "USD", digits = 0, sep = " ")), "USD 1,000")
  expect_equal(format(currency("$ 123,234.50", sep = " ")), "$ 123,234.50")
  expect_warning(currency("a"))
  expect_equal(currency("$ 123,234.50"), currency(123234.50))
  expect_equal(currency(c("$ 123,234.50", "$123.503")),
    currency(c(123234.500, 123.503), digits = 3))
  expect_equal(currency(c("HK$ 123,234.50", "HK$ 123.503"), symbol = "HK$"),
    currency(c(123234.500, 123.503), symbol = "HK$", digits = 3))
  expect_equal(currency(c("HK$ 123,234.50", "HK$ 123.503")),
    currency(c(123234.500, 123.503), symbol = "HK$", digits = 3))
  expect_is(currency(NA), "numeric")
})

test_that("accounting", {
  data <- c(-5300,10500,20300,35010)
  obj <- accounting(data)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj), c("(5,300.00)","10,500.00","20,300.00","35,010.00"))
  expect_equal(format(accounting(data, digits = 0)), c("(5,300)","10,500","20,300","35,010"))
  expect_equal(format(accounting(obj, digits = 0, big.mark = "/")),
    c("(5/300)","10/500","20/300","35/010"))
  expect_warning(accounting("a"))
  expect_equal(accounting(c("123,23.50", "(123.243)")),
    accounting(c(12323.5, -123.243), digits = 3))
  expect_is(accounting(NA), "numeric")
})

test_that("scientific", {
  data <- c(-5300,10500,20300,35010)
  obj <- scientific(data)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(scientific(data, format = "e", digits = 2)),
    c("-5.30e+03","1.05e+04","2.03e+04","3.50e+04" ))
  expect_equal(format(scientific(data, format = "E", digits = 2)),
    c("-5.30E+03","1.05E+04","2.03E+04","3.50E+04" ))
  expect_warning(scientific("a"), "NA")
  expect_is(scientific(NA), "numeric")
})

test_that("prefix", {
  data <- 1:10
  obj <- prefix(data)
  expect_is(obj, c("formattable", "integer"))
  expect_equal(format(prefix(data, "Item", sep = " ")),
    paste("Item", data))
  expect_equal(format(prefix(c(data, NA), "Item", sep = " ", na.text = "missing")),
    c(paste("Item", data), "missing"))

  data <- rnorm(10)
  expect_equal(format(prefix(data, "?", format = "f", digits = 2L)),
    paste0("?", formatC(data, format = "f", digits = 2L)))
  expect_equal(format(prefix(percent(data), ">")),
    paste0(">", format(percent(data))))
  expect_equal(format(prefix(percent(data), ">") + 0.1),
    paste0(">", format(percent(data) + 0.1)))
})

test_that("suffix", {
  data <- 1:10
  obj <- suffix(data)
  expect_is(obj, c("formattable", "integer"))
  expect_equal(format(suffix(data, "px")), paste0(data, "px"))
  expect_equal(format(suffix(c(data, NA), "km/h", sep = " ", na.text = "missing")),
    c(paste(data, "km/h"), "missing"))

  data <- rnorm(10)
  expect_equal(format(suffix(data, "?", format = "f", digits = 2L)),
    paste0(formatC(data, format = "f", digits = 2L), "?"))
  expect_equal(format(suffix(percent(data), ">")),
    paste0(format(percent(data)), ">"))
  expect_equal(format(suffix(percent(data), ">") + 0.1),
    paste0(format(percent(data) + 0.1), ">"))
})
