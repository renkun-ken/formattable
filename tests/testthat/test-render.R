context("htmlwidget")

test_that("conversion", {
  expect_is(as.htmlwidget(formattable(mtcars)), c("formattable_widget", "htmlwidget"))
})

test_that("shiny", {
  # some preliminary testing for shiny functionality
  expect_is(renderFormattable(formattable(head(mtcars))), c("shiny.render.function", "function"))
  expect_is(formattableOutput(0), c("shiny.tag.list", "list"))
})
