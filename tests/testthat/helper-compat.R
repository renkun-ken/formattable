expect_equivalent <- function(x, y) {
  expect_equal(x, y, ignore_attr = TRUE)
}
