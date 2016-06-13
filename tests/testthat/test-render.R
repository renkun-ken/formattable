context("htmlwidget")

test_that("conversion", {
  expect_is(as.htmlwidget(formattable(mtcars)), c("formattable_widget", "htmlwidget"))
})

test_that("shiny", {
  # some preliminary testing for shiny functionality
  expect_is(renderFormattable(formattable(head(mtcars))), c("shiny.render.function", "function"))
  expect_is(formattableOutput(0), c("shiny.tag.list", "list"))
})

test_that("as.datatable", {
  f <- formattable(mtcars, list(
    mpg = color_tile("transparent", "lightgray"),
    cyl = color_bar("gray"),
    area(col = vs:carb) ~ formatter("span", style = x ~ style(color = ifelse(x > 0, "red", NA)))))
  dt <- as.datatable(f)
  expect_is(dt, c("datatables", "htmlwidget"))
})
