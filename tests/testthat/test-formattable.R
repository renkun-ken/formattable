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
  expect_is(as.character(obj), "character")
  expect_equivalent(format(obj[1:4]), formatC(num[1:4], format = "f", digits = 4L))
  expect_equivalent(format(obj[[3]]), formatC(num[[3]], format = "f", digits = 4L))
  expect_equivalent(format(obj + 0.123456), formatC(num + 0.123456, format = "f", digits = 4L))
  expect_equivalent(format(obj - 0.123456), formatC(num - 0.123456, format = "f", digits = 4L))
  expect_equivalent(format(-obj), formatC(-num, format = "f", digits = 4L))
  expect_equivalent(format(obj * 0.123456), formatC(num * 0.123456, format = "f", digits = 4L))
  expect_equivalent(format(obj / 0.123456), formatC(num / 0.123456, format = "f", digits = 4L))
  expect_equivalent(formattable(1:10) %% 2, formattable(1:10 %% 2))
  expect_equivalent(rep(formattable(1), 3), formattable(rep(1, 3)))
  expect_equivalent(format(max(obj)), formatC(max(num), format = "f", digits = 4L))
  expect_equivalent(format(min(obj)), formatC(min(num), format = "f", digits = 4L))
  expect_equivalent(format(sum(obj)), formatC(sum(num), format = "f", digits = 4L))
  expect_equivalent(format(mean(obj)), formatC(mean(num), format = "f", digits = 4L))
  expect_equivalent(format(diff(obj)), formatC(diff(num), format = "f", digits = 4L))
  expect_equivalent(format(unique(obj)), formatC(unique(num), format = "f", digits = 4L))
  expect_equivalent(format(cummax(obj)), formatC(cummax(num), format = "f", digits = 4L))
  expect_equivalent(format(cummin(obj)), formatC(cummin(num), format = "f", digits = 4L))
  expect_equivalent(format(cumsum(obj)), formatC(cumsum(num), format = "f", digits = 4L))
  expect_equivalent(format(median(obj)), formatC(median(num), format = "f", digits = 4L))
  expect_equivalent(format(quantile(obj)), formatC(quantile(num), format = "f", digits = 4L))
  expect_equivalent(format(sort(obj)), formatC(sort(num), format = "f", digits = 4L))
  expect_equivalent(c(formattable(1), 2), formattable(c(1,2)))
  expect_output(invisible(print(formattable(2, digits = 4, format = "f"))), "^\\[1\\] 2.0000$")
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
  expect_equal(format(c(obj, as.factor("c"))), vmap(c(values, as.factor("c")), a = "good", b = "fair", c = "bad"))
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
  dt <- as.POSIXlt("2015-01-01")
  obj <- formattable(dt, format = "%Y%m%dT%H%M%S")
  expect_is(obj, c("formattable", "POSIXlt"))
  expect_equal(format(obj), format(dt, "%Y%m%dT%H%M%S"))
})

test_that("foramttable operators", {
  expect_equal(format(formattable(1:10) + 0.5), formatC(1:10 + 0.5))
  expect_equal(format(0.5 + formattable(1:10)), formatC(0.5 + 1:10))
  expect_equal(format(percent(0.5) * 2), "100.00%")
  expect_equal(format(2 * percent(0.5)), "100.00%")
})

test_that("formattable methods", {
  expect_equal(as.list(percent(c(0.1, 0.2))),
    list(percent(0.1), percent(0.2)))
  expect_equal(lapply(percent(c(0.1, 0.2)), identity),
    list(percent(0.1), percent(0.2)))
})

test_that("formattable.data.frame", {
  obj <- formattable(mtcars)
  expect_is(obj, c("formattable", "data.frame"))
  expect_is(format_table(obj), "knitr_kable")
  expect_is(formattable(mtcars, list(mpg = formatter("span",
        style = x ~ style(display = "block",
        "border-radius" = "4px",
        "padding-right" = "4px",
        color = "white",
        "background-color" = rgb(x/max(x), 0, 0)))))
  , "formattable")
  expect_is(formattable(mtcars, list(mpg = formatter("span",
    style = function(x) ifelse(x > median(x), "color:red", NA)))),
    "formattable")
  expect_is(format_table(mtcars, list(mpg = formatter("span",
    style = function(x) ifelse(x > median(x), "color:red", NA)))),
    "knitr_kable")
  expect_is(format_table(mtcars,
    list(vs = x ~ formattable(as.logical(x), "yes", "no"))),
    "knitr_kable")
  expect_is(format_table(mtcars, list(vs = ~"unknown")), "knitr_kable")
  expect_error(format_table(mtcars, list(vs = f(a,b) ~ "unknown")))
  expect_true({capture.output(print(formattable(mtcars))); TRUE})

  df <- data.frame(id = integer(), name = character(), value = numeric())
  expect_true({capture.output(print(formattable(df, list(value = color_tile("red", "blue")))));TRUE})
})

test_that("formattable.matrix", {
  m <- rnorm(100)
  dim(m) <- c(50,2)
  colnames(m) <- c("a","b")
  expect_is(formattable(m), "formattable")
})

test_that("is.formattable", {
  expect_equal(is.formattable(1), FALSE)
  expect_equal(is.formattable(formattable(1)), TRUE)
})
