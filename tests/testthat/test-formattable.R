context("formattable")

test_that("formattable", {
  expect_is(formattable(mtcars), "formattable")
  expect_is(format_table(formattable(mtcars)), "knitr_kable")
})
