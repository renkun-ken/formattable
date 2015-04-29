context("formats")

test_that("percent", {
  obj <- percent(c(0.15,0.252,0.3003))
  expect_is(obj, "formattable")
  expect_equal(format(obj), c("15.00%","25.20%","30.03%"))
  expect_equal(format(obj, digits = 0), c("15%","25%","30%"))
})
