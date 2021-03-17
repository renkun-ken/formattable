test_that("prefix", {
  expect_identical(format(prefix(numeric())), character())

  data <- 1:10
  obj <- prefix(data)
  expect_s3_class(obj, c("formattable", "integer"))
  expect_equal(
    format(prefix(data, "Item", sep = " ")),
    paste("Item", data)
  )
  expect_equal(
    format(prefix(c(data, NA), "Item", sep = " ", na.text = "missing")),
    c(paste("Item", data), "missing")
  )

  data <- rnorm(10)
  expect_equal(
    format(prefix(data, "?", format = "f", digits = 2L)),
    paste0("?", formatC(data, format = "f", digits = 2L))
  )
  expect_equal(
    format(prefix(percent(data), ">")),
    paste0(">", format(percent(data)))
  )
  expect_equal(
    format(prefix(percent(data), ">") + 0.1),
    paste0(">", format(percent(data) + 0.1))
  )
})
