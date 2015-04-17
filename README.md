# formattable

[![Travis-CI Build Status](https://travis-ci.org/renkun-ken/formattable.png?branch=master)](https://travis-ci.org/renkun-ken/formattable) [![Coverage Status](https://coveralls.io/repos/renkun-ken/formattable/badge.svg)](https://coveralls.io/r/renkun-ken/formattable) [![Issue Stats](http://issuestats.com/github/renkun-ken/formattable/badge/issue?style=flat)](http://issuestats.com/github/renkun-ken/formattable) [![Issue Stats](http://issuestats.com/github/renkun-ken/formattable/badge/pr?style=flat)](http://issuestats.com/github/renkun-ken/formattable)

In a typical workflow of dynamic document production, [knitr](https://github.com/yihui/knitr) and [rmarkdown](http://rmarkdown.rstudio.com/) are powerful tools to render documents with R code to different types of portable documents.

knitr is able to render an RMarkdown document (markdown document with R code chunks) to Markdown document. rmarkdown calls [pandoc](http://johnmacfarlane.net/pandoc) to render a markdown document to HTML web page. To put a table (`data.frame` in R) on the page, one may call `knitr::kable` to produce its markdown representation. By default the resulted table is in a plain theme with no additional formatting. However, in some cases, additional formatting may help clarify the information and make contrast of the data. This package provides functions to produce formatted tables in dynamic documents.

**This package is still on an initial stage. The APIs may change without notice.**

## Install

Currently, the package is only available on GitHub.

```r
# install.packages("devtools")
devtools::install_github("renkun-ken/formattable")
```

## Examples


```r
df <- data.frame(
  id = 1:10,
  name = c("Bob", "Ashley", "James", "David", "Jenny", 
    "Hans", "Leo", "John", "Emily", "Lee"), 
  age = c(28, 27, 30, 28, 29, 29, 27, 27, 31, 30),
  grade = c("C", "A", "A", "C", "B", "B", "B", "A", "C", "C"),
  test1_score = c(8.9, 9.5, 9.6, 8.9, 9.1, 9.3, 9.3, 9.9, 8.5, 8.6),
  test2_score = c(9.1, 9.1, 9.2, 9.1, 8.9, 8.5, 9.2, 9.3, 9.1, 8.8),
  final_score = c(9, 9.3, 9.4, 9, 9, 8.9, 9.25, 9.6, 8.8, 8.7),
  registered = c(TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE),
  stringsAsFactors = FALSE)
```

Plain table:


| id|name   | age|grade | test1_score| test2_score| final_score|registered |
|--:|:------|---:|:-----|-----------:|-----------:|-----------:|:----------|
|  1|Bob    |  28|C     |         8.9|         9.1|        9.00| TRUE      |
|  2|Ashley |  27|A     |         9.5|         9.1|        9.30|FALSE      |
|  3|James  |  30|A     |         9.6|         9.2|        9.40| TRUE      |
|  4|David  |  28|C     |         8.9|         9.1|        9.00|FALSE      |
|  5|Jenny  |  29|B     |         9.1|         8.9|        9.00| TRUE      |
|  6|Hans   |  29|B     |         9.3|         8.5|        8.90| TRUE      |
|  7|Leo    |  27|B     |         9.3|         9.2|        9.25| TRUE      |
|  8|John   |  27|A     |         9.9|         9.3|        9.60|FALSE      |
|  9|Emily  |  31|C     |         8.5|         9.1|        8.80|FALSE      |
| 10|Lee    |  30|C     |         8.6|         8.8|        8.70|FALSE      |

Formatted table with the following visualizations:

* Ages are rendered in gradient.
* All A grades are displayed in green bold.
* `test1_score` and `test2_score` are indicated by horizontal bars and are background-colorized: white (low score) to pink (high score)
* `final_score` shows score and ranking. Top 3 are green, and others are gray.
* `registered` texts are transformed to an icon and yes/no text.


```r
library(formattable)
score_bar <- formatter("span", 
  style = x ~ style(
    border.radius = "4px",
    padding.right = "4px",
    padding.left = sprintf("%.2fpx", 6 + 54 * normalize(x)),
    background = csscolor(gradient(x, "white", "pink"))
  ))

formattable(df, list(
  age = formatter("span", 
  style = x ~ style(
    display = "block", 
    border.radius = "4px",
    padding.right = "4px",
    background = csscolor(gradient(x, "white", "orange")))),
  grade = formatter("span",
    style = x ~ ifelse(x == "A", style(color = "green", font.weight = "bold"), NA)),
  test1_score = score_bar,
  test2_score = score_bar,
  final_score = formatter("span",
    style = x ~ style(color = ifelse(rank(-x) <= 3, "green", "gray")),
    x ~ sprintf("%.2f (rank: %02d)", x, rank(-x))),
  registered = formatter("span", 
    style = x ~ style(color = ifelse(x, "green", "red")),
    x ~ icontext(ifelse(x, "ok", "remove"), ifelse(x, "Yes", "No")))
))
```

![formattable](./formattable.png?raw=true)

## License

This package is under [MIT License](http://opensource.org/licenses/MIT).
