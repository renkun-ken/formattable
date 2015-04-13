context("text")

test_that("percent", {
  expect_equal(percent(c(0.15,0.252,0.3003)), c("15.00%","25.20%","30.03%"))
  expect_equal(percent(c(0.15,0.252,0.3003), digits = 0), c("15%","25%","30%"))
})
