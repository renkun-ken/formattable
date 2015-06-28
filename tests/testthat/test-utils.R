context("utils")

test_that("get_digtis", {
  expect_equal(get_digits(c("0.1", "0.01", ".501", ".5001", "123.321")), c(1, 2, 3, 4, 3))
})
