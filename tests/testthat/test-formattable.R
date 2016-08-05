context("formattable")

test_that("formattable.default", {
  obj <- structure(list(x = 1,y = 2), class = c("test_object", "list"))
  fobj <- formattable(obj, formatter = function(obj) {
    digits <- attr(obj, "formattable", TRUE)$format$digits
    if (is.null(digits)) digits <- 2L
    sprintf("text_object { x: %s, y: %s }", round(obj$x, digits), round(obj$y, digits))
  })
  expect_is(fobj, c("formattable", "test_object", "list"))
  expect_equal(fobj$x, obj$x)
  expect_equal(fobj$y, obj$y)
  expect_equal(format(fobj), "text_object { x: 1, y: 2 }")
})

test_that("formattable.numeric", {
  num <- rnorm(10)
  obj <- formattable(num, format = "f", digits = 2L)
  expect_is(obj, c("formattable", "numeric"))
  expect_equal(format(obj), formatC(num, format = "f", digits = 2L))
  expect_equal(format(c(obj, 0.1)), formatC(c(num,0.1), format = "f", digits = 2L))

  num <- 1:10
  obj <- formattable(num)
  obj_attr <- attr(obj, "formattable", TRUE)
  expect_is(obj, c("formattable", "integer"))
  obj[5] <- 0L
  expect_is(obj, c("formattable", "integer"))
  expect_identical(attr(obj, "formattable", TRUE), obj_attr)

  obj[5] <- 2.5
  expect_is(obj, c("formattable", "numeric"))
  expect_identical(attr(obj, "formattable", TRUE), obj_attr)

  obj[6] <- "abc"
  expect_is(obj, c("formattable", "character"))
  expect_identical(attr(obj, "formattable", TRUE), obj_attr)

  num <- 1:10
  obj <- formattable(num)
  obj_attr <- attr(obj, "formattable", TRUE)
  expect_is(obj, c("formattable", "integer"))
  obj[[5]] <- 0L
  expect_is(obj, c("formattable", "integer"))
  expect_identical(attr(obj, "formattable", TRUE), obj_attr)

  obj[[5]] <- 2.5
  expect_is(obj, c("formattable", "numeric"))
  expect_identical(attr(obj, "formattable", TRUE), obj_attr)

  obj[[6]] <- "abc"
  expect_is(obj, c("formattable", "character"))
  expect_identical(attr(obj, "formattable", TRUE), obj_attr)

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
  expect_identical(cop_create_obj(`+`, "test", 1,2), structure(3, class = c("test", "numeric")))
  expect_output(invisible(print(formattable(2, digits = 4, format = "f"))), "^\\[1\\] 2.0000$")
})

test_that("formattable.table", {
  # 1d table
  x <- rbinom(100, 8, 0.5)
  tx <- table(x)
  fx <- formattable(tx)
  expect_is(fx, c("formattable", "table"))
  expect_true(is.integer(fx))
  expect_identical(names(format(fx)), names(tx))
  expect_equal(format(fx), format(tx))

  # 2d table
  y <- rbinom(100, 3, 0.6)
  tx <- table(x, y)
  fx <- formattable(tx)
  expect_is(fx, c("formattable", "table"))
  expect_true(is.matrix(fx))
  expect_true(is.integer(fx))
  expect_identical(dimnames(fx), dimnames(tx))
  expect_equal(format(fx), format(tx))
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

test_that("render_html_matrix", {
  d <- data.frame(a = c(1, 2), b = c(1.23456, 2.5),
    c = c("a", "b"), d = as.Date("2016-01-05") + 0:1)
  fd <- render_html_matrix.data.frame(d)
  expect_true(is.matrix(fd) && is.character(fd))
  expect_equal(fd,
    matrix(c("1", "2",
      "1.23456", "2.50000",
      "a", "b",
      "2016-01-05",  "2016-01-06"),
      nrow = 2L, ncol = 4L,
      dimnames = list(c("1", "2"), c("a", "b", "c", "d"))))
})

test_that("formattable.data.frame", {
  obj <- formattable(mtcars)
  expect_is(obj, c("formattable", "data.frame"))
  expect_is(format_table(mtcars), "knitr_kable")
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

  df <- formattable(mtcars, list(mpg = color_tile("red", "green")))
  expect_identical(attr(df, "formattable", TRUE), attr(df[1:10, ], "formattable", TRUE))
  expect_identical(attr(df, "formattable", TRUE), attr(df[, c("cyl", "mpg")], "formattable", TRUE))
  expect_identical(attr(df, "formattable", TRUE), attr(df[1:10, c("cyl", "mpg")], "formattable", TRUE))
  knit_df <- knit_print.formattable(df)
  expect_is(knit_df, "knit_asis")
  expect_true(is.character(knit_df))

  df <- data.frame(id = integer(), name = character(), value = numeric())
  expect_is(format_table(formattable(df, list(value = color_tile("red", "blue")))), "knitr_kable")

  # formula
  df <- data.frame(a = rnorm(10, 0.1), b = rnorm(10, 0.1), c = rnorm(10, 0.1))
  format_table(df, list(~ percent))

  # cross formatting
  format_table(df, list(b = formatter("span", style = ~ style(color = ifelse(a >= mean(a), "red", "green")))))

  # hiding columns
  format_table(df, list(a = FALSE))

  # area formatter
  df <- data.frame(a = rnorm(10, 0.1), b = rnorm(10, 0.1), c = rnorm(10, 0.1))
  expect_is(format_table(df, list(area(col = c("a", "b")) ~ percent)), "knitr_kable")
  expect_is(format_table(df, list(area(col = b:c) ~ percent)), "knitr_kable")
  expect_is(format_table(df, list(area(1:5) ~ percent)), "knitr_kable")
  expect_is(format_table(df, list(area(1:5, b:c) ~ percent)), "knitr_kable")

  expect_error(format_table(df, list(x ~ percent)))
  expect_error(format_table(df, list(get("df") ~ percent)))
})

test_that("formattable matrix", {
  m <- rnorm(100)
  dim(m) <- c(50,2)
  colnames(m) <- c("a","b")
  fm <- formattable(m)
  expect_is(fm, c("formattable", "matrix"))
  expect_true(is.matrix(fm))
  expect_equal(dim(fm), dim(m))
  fmt <- format(fm)
  expect_true(is.character(fmt))
  expect_true(is.matrix(fmt))
  expect_equal(dim(fmt), dim(m))

  m <- matrix(rnorm(4, 0.1), 2)
  fm <- formattable(m)
  fm[1, 1] <- m[1, 1] <- 0.1
  expect_true(all(fm == m))
})

test_that("formattable array", {
  m <- array(rnorm(60), c(3, 4, 5),
    list(letters[1:3], letters[1:4], letters[1:5]))
  fm <- formattable(m)
  expect_is(fm, c("formattable", "array"))
  expect_true(is.array(fm))
  expect_equal(dim(fm), dim(m))
  fmt <- format(fm)
  expect_true(is.character(fmt))
  expect_true(is.array(fmt))
  expect_equal(dim(fmt), dim(m))

  m <- array(rnorm(24, 0.1), c(2, 3, 4))
  fm <- formattable(m)
  fm[1, 1, 1] <- m[1, 1, 1] <- 0.1
  expect_true(all(fm == m))
})

test_that("is.formattable", {
  expect_equal(is.formattable(1), FALSE)
  expect_equal(is.formattable(formattable(1)), TRUE)
})
