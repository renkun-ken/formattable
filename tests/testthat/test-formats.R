context("formats")

test_that("accounting", {
  expect_identical(format(accounting(numeric())), character())

  data <- c(-5300, 10500, 20300, 35010)
  obj <- accounting(data)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj), c("(5,300.00)", "10,500.00", "20,300.00", "35,010.00"))
  expect_equal(format(accounting(data, digits = 0)), c("(5,300)", "10,500", "20,300", "35,010"))
  expect_equal(format(accounting(obj, digits = 0, big.mark = "/")),
    c("(5/300)", "10/500", "20/300", "35/010"))
  expect_warning(accounting("a"))
  expect_equal(accounting(c("123,23.50", "(123.243)")),
    accounting(c(12323.5, -123.243), digits = 3))
  expect_is(accounting(NA), "numeric")
})

test_that("scientific", {
  expect_identical(format(scientific(numeric())), character())

  data <- c(-5300, 10500, 20300, 35010)
  obj <- scientific(data)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(scientific(data, format = "e", digits = 2)),
    c("-5.30e+03", "1.05e+04", "2.03e+04", "3.50e+04"))
  expect_equal(format(scientific(data, format = "E", digits = 2)),
    c("-5.30E+03", "1.05E+04", "2.03E+04", "3.50E+04"))
  expect_warning(scientific("a"), "NA")
  expect_is(scientific(NA), "numeric")
})

test_that("prefix", {
  expect_identical(format(prefix(numeric())), character())

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
  expect_identical(format(suffix(numeric())), character())

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
