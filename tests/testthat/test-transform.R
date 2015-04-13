context("transform")

test_that("switches", {
  expect_equal(switches(c(1,1,2,2,3),"a","b","c"), c("a","a","b","b","c"))
  expect_equal(switches(c("a","b","a","c"), a=1,b=2,c=3), c(1,2,1,3))
  expect_equal(switches(c("a","b","a","c","d"), a=1,b=2,c=3,0), c(1,2,1,3,0))
  expect_equal(switches(c("a","b","a","c"), a=1,b=2,c=3, SIMPLIFY = FALSE), list(1,2,1,3))
})
