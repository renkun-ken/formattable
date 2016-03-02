context("transform")

test_that("vmap", {
  expect_equal(vmap(c(1,1,2,2,3),"a","b","c"), c("a","a","b","b","c"))
  expect_equal(vmap(c("a","b","a","c"), a=1,b=2,c=3), c(1,2,1,3))
  expect_equal(vmap(c("a","b","a","c","d"), a=1,b=2,c=3,0), c(1,2,1,3,0))
  expect_equal(vmap(c("a","b","a","c"), a=1,b=2,c=3, SIMPLIFY = FALSE), list(1,2,1,3))
})

test_that("qrank", {
  n <- 100
  x <- rnorm(n)
  expect_equal(qrank(x), rank(x) / length(x))
  expect_equal(qrank(-x), rank(-x) / length(x))

  x <- rnorm(n)
  x[sample(1:n, 10, replace = FALSE)] <- NA
  expect_equal(qrank(x), rank(x) / length(x))
  expect_equal(qrank(-x), rank(-x) / length(x))
  expect_equal(qrank(x, na.last = FALSE), rank(x, na.last = FALSE) / length(x))
  expect_equal(qrank(-x, na.last = FALSE), rank(-x, na.last = FALSE) / length(x))
})

test_that("normalize", {
  n <- 100
  x <- rnorm(n)
  expect_equal(normalize(x), (x - min(x)) / (max(x) - min(x)))
  expect_equal(normalize(x, 0.5, 0.8), 0.5 + 0.3 * normalize(x))
  expect_error(normalize(x, 0.5, 0.1))

  x <- rnorm(n)
  x <- x - min(x, na.rm = TRUE) + 1
  x[sample(1:n, 10, replace = FALSE)] <- NA
  expect_error(normalize(x), "missing value")
  expect_equal(normalize(x, na.rm = TRUE),
    (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)))

  expect_equal(normalize(c(NA,NA,NA), na.rm = TRUE), c(0,0,0))
})

test_that("proportion", {
  n <- 100
  x <- rbinom(n, 100, 0.8)
  expect_equal(proportion(x), x / max(abs(x)))

  x <- rnorm(n)
  expect_equal(proportion(x), x / max(abs(x)))
})
