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
