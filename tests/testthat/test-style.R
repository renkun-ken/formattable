context("style")

test_that("style", {
  expect_equal(style(color = "red"), "color: red")
  expect_equal(style(color = "red", border = "1px"), "color: red; border: 1px")
  expect_equal(style(color = NA, border = "1px"), "border: 1px")
  expect_equal(style(color = c("red", "green")), c("color: red", "color: green"))
  expect_equal(style(color = c("red", "green"), border = "1px"), c("color: red; border: 1px", "color: green; border: 1px"))
  expect_equal(style(color = c("red", "green"), border = c("1px", "2px")), c("color: red; border: 1px", "color: green; border: 2px"))
  expect_equal(style(color = c("red", NA), border = "1px"), c("color: red; border: 1px", "border: 1px"))
  expect_equal(style(color = c("red", NA), border = c("1px", "2px")), c("color: red; border: 1px", "border: 2px"))
})

test_that("icontext", {
  expect_equal(as.character(icontext("plus")),
    as.character(htmltools::tags$i(class = "glyphicon glyphicon-plus")))

  icon_names <- c("plus", "minus")
  texts <- c("hello", "world")

  expect_equal(vapply(icontext(icon_names), as.character, character(1L)),
    vapply(icon_names, function(icon) {
      as.character(htmltools::tags$i(class = paste0("glyphicon glyphicon-", icon)))
    }, character(1L), USE.NAMES = FALSE))


  expect_equal(vapply(icontext(icon_names, texts), as.character, character(1L)),
    vapply(.mapply(function(icon, text) {
      htmltools::tagList(htmltools::tags$i(class = paste0("glyphicon glyphicon-", icon)), text)
    }, list(icon_names, texts), NULL), as.character, character(1L)))

  stars <- c(2,5,3)
  icon_names <- lapply(stars, function(n) rep("plus", n))
  texts <- sprintf("level %d", stars)

  expect_equal(vapply(icontext(icon_names), as.character, character(1L)),
    vapply(icon_names, function(icon) {
      as.character(htmltools::tagList(lapply(icon, function(i)
        htmltools::tags$i(class = paste0("glyphicon glyphicon-", i)))))
    }, character(1L)))

  expect_equal(vapply(icontext(icon_names, texts), as.character, character(1L)),
    vapply(.mapply(function(icon, text) {
      htmltools::tagList(lapply(icon, function(i)
        htmltools::tags$i(class = paste0("glyphicon glyphicon-", i))), text)
    }, list(icon_names, texts), NULL), as.character, character(1L)))
})
