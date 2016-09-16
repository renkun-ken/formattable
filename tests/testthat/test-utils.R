context("utils")

test_that("call_or_default", {
  expect_identical(call_or_default(NULL, 0), 0)
  expect_identical(call_or_default(sin, 1), sin(1))
})

test_that("get_digtis", {
  expect_equal(get_digits(c("0.1", "0.01", ".501", ".5001", "123.321", "123", "012", "5.")),
    c(1, 2, 3, 4, 3, 0, 0, 0))
})

test_that("copy_dim", {
  x <- c(1, 2, 3)
  y <- format(x)
  expect_true(!is.array(copy_dim(x, y)))

  x <- c(1,2,3,4)
  m <- matrix(x, 2, dimnames = list(c("a", "b")))
  y <- format(x)
  y2 <- copy_dim(m, y)
  expect_true(is.matrix(y2))
  expect_identical(dim(y2), dim(m))
  expect_identical(dimnames(y2), dimnames(m))

  x <- rnorm(24)
  arr <- array(x, c(2, 3, 4),
    dimnames = list(letters[1:2], letters[1:3], letters[1:4]))
  y <- format(x)
  y2 <- copy_dim(arr, y)
  expect_true(is.array(y2))
  expect_identical(dim(y2), dim(arr))
  expect_identical(dimnames(y2), dimnames(arr))
})
