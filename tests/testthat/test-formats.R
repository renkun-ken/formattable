context("formats")

test_that("percent", {
  data <- c(-0.05, 0.15,0.252,0.3003)
  obj <- percent(data)
  expect_is(obj, "formattable")
  expect_equal(format(obj), c("-5.00%","15.00%","25.20%","30.03%"))
  expect_equal(format(percent(data, digits = 0)), c("-5%","15%","25%","30%"))
  expect_equal(format(percent(obj, digits = 0)), c("-5%","15%","25%","30%"))
  expect_error(percent("a"))
})

test_that("comma", {
  data <- c(-5300,10500,20300,35010)
  obj <- comma(data)
  expect_is(obj, "formattable")
  expect_equal(format(obj), c("-5,300.00","10,500.00","20,300.00","35,010.00"))
  expect_equal(format(comma(data, digits = 0)), c("-5,300","10,500","20,300","35,010"))
  expect_equal(format(comma(obj, digits = 0, big.mark = "/")),
    c("-5/300","10/500","20/300","35/010"))
  expect_error(comma("a"))
})

test_that("currency", {
  data <- c(-5300,10500,20300,35010)
  obj <- currency(data)
  expect_is(obj, "formattable")
  expect_equal(format(obj), c("$-5,300.00","$10,500.00","$20,300.00","$35,010.00"))
  expect_equal(format(currency(data, digits = 0)), c("$-5,300","$10,500","$20,300","$35,010"))
  expect_equal(format(currency(obj, digits = 0, big.mark = "/")),
    c("$-5/300","$10/500","$20/300","$35/010"))
  expect_equal(format(currency(1000, "USD", digits = 0, sep = " ")), "USD 1,000")
  expect_error(currency("a"))
})

test_that("accounting", {
  data <- c(-5300,10500,20300,35010)
  obj <- accounting(data)
  expect_is(obj, "formattable")
  expect_equal(format(obj), c("(5,300.00)","10,500.00","20,300.00","35,010.00"))
  expect_equal(format(accounting(data, digits = 0)), c("(5,300)","10,500","20,300","35,010"))
  expect_equal(format(accounting(obj, digits = 0, big.mark = "/")),
    c("(5/300)","10/500","20/300","35/010"))
  expect_error(accounting("a"))
})

test_that("scientific", {
  data <- c(-5300,10500,20300,35010)
  obj <- scientific(data)
  expect_is(obj, "formattable")
  expect_equal(format(scientific(data, format = "e", digits = 2)),
    c("-5.30e+03","1.05e+04","2.03e+04","3.50e+04" ))
  expect_equal(format(scientific(data, format = "E", digits = 2)),
    c("-5.30E+03","1.05E+04","2.03E+04","3.50E+04" ))
  expect_error(scientific("a"))
})

test_that("prefix", {
  data <- 1:10
  obj <- prefix(data)
  expect_is(obj, "formattable")
  expect_equal(format(prefix(data, "Item", sep = " ")),
    paste("Item", data))
  expect_equal(format(prefix(c(data, NA), "Item", sep = " ", na.text = "missing")),
    c(paste("Item", data), "missing"))

  data <- rnorm(10)
  expect_equal(format(prefix(data, "?", format = "f", digits = 2L)),
    paste0("?", formatC(data, format = "f", digits = 2L)))
})

test_that("suffix", {
  data <- 1:10
  obj <- suffix(data)
  expect_is(obj, "formattable")
  expect_equal(format(suffix(data, "px")), paste0(data, "px"))
  expect_equal(format(suffix(c(data, NA), "km/h", sep = " ", na.text = "missing")),
    c(paste(data, "km/h"), "missing"))

  data <- rnorm(10)
  expect_equal(format(suffix(data, "?", format = "f", digits = 2L)),
    paste0(formatC(data, format = "f", digits = 2L), "?"))
})
