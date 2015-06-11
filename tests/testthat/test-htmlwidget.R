context("htmlwidget")

library(htmlwidgets)

test_that("conversion", {
  expect_is( as.htmlwidget(formattable(mtcars)), "formattable_widget" )
  expect_is( as.htmlwidget(formattable(mtcars)), "htmlwidget" )
})

test_that("htmloutput",{
  expect_identical(
    as.htmlwidget(formattable(mtcars[1,]))$x$html
    , "<table><thead>\n<tr>\n<th align=\"left\"></th>\n<th align=\"right\">mpg</th>\n<th align=\"right\">cyl</th>\n<th align=\"right\">disp</th>\n<th align=\"right\">hp</th>\n<th align=\"right\">drat</th>\n<th align=\"right\">wt</th>\n<th align=\"right\">qsec</th>\n<th align=\"right\">vs</th>\n<th align=\"right\">am</th>\n<th align=\"right\">gear</th>\n<th align=\"right\">carb</th>\n</tr>\n</thead><tbody>\n<tr>\n<td align=\"left\">Mazda RX4</td>\n<td align=\"right\">21</td>\n<td align=\"right\">6</td>\n<td align=\"right\">160</td>\n<td align=\"right\">110</td>\n<td align=\"right\">3.9</td>\n<td align=\"right\">2.62</td>\n<td align=\"right\">16.46</td>\n<td align=\"right\">0</td>\n<td align=\"right\">1</td>\n<td align=\"right\">4</td>\n<td align=\"right\">4</td>\n</tr>\n</tbody></table>\n"
  )
})
