test_that("formatter", {
  expect_s3_class(formatter("span", style = "color:red"), "function")
  expect_equal(formatter("span", style = "color: red")(c(1, 2, 3)),
    sprintf('<span style="color: red">%s</span>', c(1, 2, 3)))
  expect_equal(formatter("span", function(x) ifelse(x, "yes", "no"))(c(1, 0, 0, 1)),
    paste0("<span>", ifelse(c(1, 0, 0, 1), "yes", "no"), "</span>"))
  expect_equal(formatter("span", x ~ ifelse(x, "yes", "no"))(1),
    paste0("<span>", ifelse(1, "yes", "no"), "</span>"))
  expect_match(capture.output(print(formatter("span"))), "formatter")
  expect_equal(local({
    yes_string <- "YES"
    no_string <- "NO"
    formatter("span", x ~ ifelse(x, yes_string, no_string))(c(TRUE, FALSE))
  }), paste0("<span>", c("YES", "NO"), "</span>"))

  # render text
  bold <- formatter("span", style = "font-weight: bold")
  expect_equal(bold(c(0.1, 0.2)),
    c("<span style=\"font-weight: bold\">0.1</span>",
      "<span style=\"font-weight: bold\">0.2</span>"))
  expect_equal(bold(percent(c(0.1, 0.2))),
    c("<span style=\"font-weight: bold\">10.00%</span>",
      "<span style=\"font-weight: bold\">20.00%</span>"))

  bold_percent <- formatter("span", style = "font-weight: bold", percent)
  expect_equal(bold_percent(c(0.1, 0.2)),
    c("<span style=\"font-weight: bold\">10.00%</span>",
      "<span style=\"font-weight: bold\">20.00%</span>"))

  # dynamic scoping of formula
  expect_equal(local({
    yes <- "yes"
    no <- "no"
    formatter("span", x ~ ifelse(x, yes, no))(c(1, 0, 0, 1))
  }), paste0("<span>", ifelse(c(1, 0, 0, 1), "yes", "no"), "</span>"))

  df <- data.frame(x = c(-1, 0, 1), y = c(-1, 0, 1))
  expect_equal(formatter("span", ~ ifelse(x >= 0 & y >= 0, "yes", "no"))(NULL, df),
    paste0("<span>", ifelse(df$x >= 0 & df$y >= 0, "yes", "no"), "</span>"))
})

test_that("area", {
  expect_s3_class(area(), "area")
  expect_type(area(), "list")
  expect_identical(area()$row, TRUE)
  expect_identical(area()$col, TRUE)

  a1 <- area(1:10, 1:3)
  expect_type(a1$row, "language")
  expect_type(a1$col, "language")
  expect_identical(a1$envir, environment())
})

test_that("formatters", {
  expect_snapshot({
    x <- c(0.1, 0.2, 0.3)
    f <- color_tile("white", "pink")
    writeLines(f(0.1))
    writeLines(f(x))
    writeLines(f(percent(x)))
  })
})
