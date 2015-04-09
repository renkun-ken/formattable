context("formattable")

test_that("formattable", {
  expect_is(formattable(mtcars), "knitr_kable")
})
