context("style")

test_that("style", {
  expect_equal(style(color = "red"), "color: red")
  expect_equal(style(color = "red", border = "1px"), "color: red; border: 1px")
  expect_equal(style(color = NA, border = "1px"), "border: 1px")
  expect_equal(style(color = c("red", "green")), c("color: red", "color: green"))
  expect_equal(style(color = c("red", "green"), border = "1px"),
    c("color: red; border: 1px", "color: green; border: 1px"))
  expect_equal(style(color = c("red", "green"), border = c("1px", "2px")),
    c("color: red; border: 1px", "color: green; border: 2px"))
  expect_equal(style(color = c("red", NA), border = "1px"),
    c("color: red; border: 1px", "border: 1px"))
  expect_equal(style(color = c("red", NA), border = c("1px", "2px")),
    c("color: red; border: 1px", "border: 2px"))
  expect_equal(style(color = "red", "border: 0px"), "color: red; border: 0px")
  expect_equal(style("color: red", "border: 0px"), "color: red; border: 0px")
  expect_equal(style(), character())
  expect_equal(style(x = 1:3, y = integer()), style(x = 1:3))
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

  stars <- 3
  icon_names <- lapply(stars, function(n) rep("plus", n))
  texts <- sprintf("level %d", stars)

  expect_equal(vapply(icontext(icon_names, texts, simplify = FALSE), as.character, character(1L)),
    vapply(.mapply(function(icon, text) {
      htmltools::tagList(lapply(icon, function(i)
        htmltools::tags$i(class = paste0("glyphicon glyphicon-", i))), text)
    }, list(icon_names, texts), NULL), as.character, character(1L)))

})

test_that("gradient", {
  expect_equal(gradient(c(1,2,3), "white", "red"),
    matrix(c(255, 255, 255, 255, 127, 127, 255, 0, 0), 3, 3,
    dimnames = list(c("red","green","blue"))))
  expect_equal(gradient(c(3,2,1), "white", "red"),
    matrix(c(255, 0, 0, 255, 127, 127, 255, 255, 255), 3, 3,
    dimnames = list(c("red","green","blue"))))
  expect_equal(gradient(c(1,3,2), "white", "red"),
    matrix(c(255, 255, 255, 255, 0, 0, 255, 127, 127), 3, 3,
    dimnames = list(c("red","green","blue"))))
  expect_equal(gradient(c(1,2,3,4), rgb(1,1,0,0), rgb(1,0,0,1), alpha = TRUE),
    matrix(c(255, 255, 0, 0, 255, 170, 0, 85, 255, 85, 0, 170, 255, 0, 0, 255), 4, 4,
      dimnames = list(c("red","green","blue","alpha"))))
  expect_equal(gradient(c(x = 1,y = 2,z = 3), "white", "red", use.names = TRUE),
    matrix(c(255, 255, 255, 255, 127, 127, 255, 0, 0), 3, 3,
      dimnames = list(c("red","green","blue"), c("x","y","z"))))
  expect_equal(gradient(c(x = 1,y = 2,z = 3), "white", "red", use.names = FALSE),
    matrix(c(255, 255, 255, 255, 127, 127, 255, 0, 0), 3, 3,
      dimnames = list(c("red","green","blue"))))
  expect_equal(gradient(c(1:3, NA), "white", "red"),
    matrix(c(255, 255, 255, 255, 127, 127, 255, 0, 0, NA, NA, NA), 3, 4,
      dimnames = list(c("red","green","blue"))))
  expect_equal(ncol(gradient(numeric(), "red", "blue")), 0L)
  expect_error(gradient(c(1:3, NA), "white", "red", na.rm = FALSE), "missing value")
})

test_that("csscolor", {
  expect_equal(csscolor(rgb(0, 0.5, 0.5)), "#008080")
  expect_equal(csscolor(c(rgb(0, 0.5, 0.5), rgb(0, 0.2, 0.5))), c("#008080","#003380"))
  expect_equal(csscolor(rgb(0, 0.5, 0.5, 1)), "rgba(0, 128, 128, 1)")
  expect_equal(csscolor(gradient(c(1,2,3,4,5), "white", "red")),
    c("#ffffff", "#ffbfbf", "#ff7f7f", "#ff3f3f", "#ff0000"))
  expect_equal(csscolor(gradient(c(1,3,2), rgb(0, 0.1, 0.2, 0.5), rgb(0, 0.1, 0.2, 1))),
    c("rgba(0, 26, 51, 0.5)", "rgba(0, 26, 51, 1)", "rgba(0, 26, 51, 0.75)"))
  expect_equal(csscolor(gradient(c(1:3, NA), "white", "red")),
    c("#ffffff", "#ff7f7f", "#ff0000", NA))
  expect_equal(csscolor(gradient(0.1, "black", "white")), "#ffffff")
})
