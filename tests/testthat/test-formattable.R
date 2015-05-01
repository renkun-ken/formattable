context("formattable")

test_that("formattable.default", {
  num <- rnorm(10)
  obj <- formattable(num, format = "f", digits = 2L)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj), formatC(num, format = "f", digits = 2L))
  expect_equal(format(c(obj, 0.1)), formatC(c(num,0.1), format = "f", digits = 2L))

  num <- rnorm(10)
  names(num) <- letters[seq_along(num)]
  obj <- formattable(num, format = "f", digits = 4L)
  expect_is(obj, c("formattable", "numeric"))
  expect_equivalent(format(obj[1:4]), formatC(num[1:4], format = "f", digits = 4L))
  expect_equivalent(format(obj[[3]]), formatC(num[[3]], format = "f", digits = 4L))
  expect_equivalent(format(obj + 0.123456), formatC(num + 0.123456, format = "f", digits = 4L))
  expect_equivalent(format(obj - 0.123456), formatC(num - 0.123456, format = "f", digits = 4L))
  expect_equivalent(format(obj * 0.123456), formatC(num * 0.123456, format = "f", digits = 4L))
  expect_equivalent(format(obj / 0.123456), formatC(num / 0.123456, format = "f", digits = 4L))
  expect_equivalent(format(max(obj)), formatC(max(num), format = "f", digits = 4L))
  expect_equivalent(format(sort(obj)), formatC(sort(num), format = "f", digits = 4L))
  expect_equivalent(c(formattable(1), 2), formattable(c(1,2)))
})

test_that("formattable.logical", {
  logi <- rnorm(10) >= 0
  obj <- formattable(logi, "yes", "no")
  expect_is(obj, c("formattable", "logical"))
  expect_equal(format(obj), ifelse(logi, "yes", "no"))
  expect_equal(format(!obj), ifelse(!logi, "yes", "no"))
  expect_equal(format(all(obj)), ifelse(all(logi), "yes", "no"))
  expect_equal(format(any(obj)), ifelse(any(logi), "yes", "no"))
  expect_equivalent(format(obj & obj), ifelse(logi & logi, "yes", "no"))
  expect_equivalent(format(obj | obj), ifelse(logi | logi, "yes", "no"))
})

test_that("formattable.factor", {
  values <- as.factor(c("a","b","b","c"))
  obj <- formattable(values, a = "good", b = "fair", c = "bad")
  expect_is(obj, c("formattable", "factor"))
  expect_equal(format(obj), vmap(values, a = "good", b = "fair", c = "bad"))
  expect_equal(format(c(obj, "c")), vmap(c(values, "c"), a = "good", b = "fair", c = "bad"))
})

test_that("formattable.Date", {
  dt <- as.Date("2015-01-01") + 1:5
  obj <- formattable(dt, format = "%Y%m%d")
  expect_is(obj, c("formattable", "Date"))
  expect_equal(format(obj), format(dt, "%Y%m%d"))
})

test_that("formattable.POSIXct", {
  dt <- as.POSIXct("2015-01-01 09:15:20") + 1:5
  obj <- formattable(dt, format = "%Y%m%dT%H%M%S")
  expect_is(obj, c("formattable", "POSIXct"))
  expect_equal(format(obj), format(dt, "%Y%m%dT%H%M%S"))
})

test_that("formattable.POSIXlt", {
  dt <- as.POSIXlt("2015-01-01 09:15:20") + 1:5
  obj <- formattable(dt, format = "%Y%m%dT%H%M%S")
  expect_is(obj, c("formattable", "POSIXlt"))
  expect_equal(format(obj), format(dt, "%Y%m%dT%H%M%S"))
})

test_that("formattable.data.frame", {
  obj <- formattable(mtcars)
  expect_is(obj, c("formattable", "data.frame"))
  expect_is(format_table(obj), "knitr_kable")
})
