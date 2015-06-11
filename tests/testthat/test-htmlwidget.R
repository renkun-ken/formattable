context("htmlwidget")

library(htmlwidgets)

test_that("conversion", {
  expect_is( as.htmlwidget(formattable(mtcars)), "formattable_widget" )
  expect_is( as.htmlwidget(formattable(mtcars)), "htmlwidget" )
})
