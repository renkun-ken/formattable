<!-- README.md is generated from README.Rmd on GitHub Actions: do not edit by hand -->

# formattable

<!-- badges: start -->

[![R build status](https://github.com/renkun-ken/formattable/workflows/rcc/badge.svg)](https://github.com/renkun-ken/formattable/actions) [![codecov.io](https://codecov.io/github/renkun-ken/formattable/coverage.svg?branch=master)](https://codecov.io/github/renkun-ken/formattable?branch=master) [![CRAN Version](https://www.r-pkg.org/badges/version/formattable)](https://cran.r-project.org/package=formattable)

<!-- badges: end -->

This package is designed for applying formatting on vectors and data frames to make data presentation easier, richer, more flexible and hopefully convey more information.

This document is also translated into [日本語](https://github.com/renkun-ken/formattable/blob/master/README.ja.md) by \[@hoxo\_m\](<https://github.com/hoxo-m>), \[@dichika\](<https://github.com/dichika>) and \[@teramonagi\](<https://github.com/teramonagi>).

## Install

The package is available on both GitHub and CRAN.

Install from GitHub:

<pre class='chroma'>
<span class='c'># install.packages("devtools")</span>
<span class='nf'>devtools</span><span class='nf'>::</span><span class='nf'><a href='https://devtools.r-lib.org//reference/remote-reexports.html'>install_github</a></span><span class='o'>(</span><span class='s'>"renkun-ken/formattable"</span><span class='o'>)</span></pre>

Install from CRAN:

<pre class='chroma'>
<span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"formattable"</span><span class='o'>)</span></pre>

## Introduction

Atomic vectors are basic units to store data. Some data can be read more easily with formatting. A numeric vector, for example, stores a group of percentage numbers yet still shows in the form of typical floating numbers. This package provides functions to create data structures with predefined formatting rules so that these objects store the original data but are printed with formatting.

The package provides several typical formattable objects such as `percent`, `comma`, `currency`, `accounting` and `scientific`. These objects are essentially numeric vectors with pre-defined formatting rules and parameters. For example,

<pre class='chroma'>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://renkun-ken.github.io/formattable/'>formattable</a></span><span class='o'>)</span>
<span class='nv'>p</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/percent.html'>percent</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>0.1</span>, <span class='m'>0.02</span>, <span class='m'>0.03</span>, <span class='m'>0.12</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>p</span></pre>
<pre class='chroma'>
<span class='c'>## [1] 10.00% 2.00%  3.00%  12.00%</span></pre>

The percent vector is no different from a numeric vector but has a percentage representation as being printed. It works with arithmetic operations and common functions and preserves its formatting.

<pre class='chroma'>
<span class='nv'>p</span> <span class='o'>+</span> <span class='m'>0.05</span></pre>
<pre class='chroma'>
<span class='c'>## [1] 15.00% 7.00%  8.00%  17.00%</span></pre>
<pre class='chroma'>
<span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>p</span><span class='o'>)</span></pre>
<pre class='chroma'>
<span class='c'>## [1] 12.00%</span></pre>
<pre class='chroma'>
<span class='nv'>balance</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/accounting.html'>accounting</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1000</span>, <span class='m'>500</span>, <span class='m'>200</span>, <span class='o'>-</span><span class='m'>150</span>, <span class='m'>0</span>, <span class='m'>1200</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>balance</span></pre>
<pre class='chroma'>
<span class='c'>## [1] 1,000.00 500.00   200.00   (150.00) 0.00     1,200.00</span></pre>
<pre class='chroma'>
<span class='nv'>balance</span> <span class='o'>+</span> <span class='m'>1000</span></pre>
<pre class='chroma'>
<span class='c'>## [1] 2,000.00 1,500.00 1,200.00 850.00   1,000.00 2,200.00</span></pre>

These functions are special cases of what [`formattable()`](https://renkun-ken.github.io/formattable/reference/formattable.html) can do. [`formattable()`](https://renkun-ken.github.io/formattable/reference/formattable.html) applies highly customizable formatting to objects of a wide range of classes like `numeric`, `logical`, `factor`, `Date`, `data.frame`, etc. A typical data frame may look more friendly with `formattable` column vectors. For example,

<pre class='chroma'>
<span class='nv'>p</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>
  id <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>3</span>, <span class='m'>4</span>, <span class='m'>5</span><span class='o'>)</span>,
  name <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"A1"</span>, <span class='s'>"A2"</span>, <span class='s'>"B1"</span>, <span class='s'>"B2"</span>, <span class='s'>"C1"</span><span class='o'>)</span>,
  balance <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/accounting.html'>accounting</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>52500</span>, <span class='m'>36150</span>, <span class='m'>25000</span>, <span class='m'>18300</span>, <span class='m'>7600</span><span class='o'>)</span>, format <span class='o'>=</span> <span class='s'>"d"</span><span class='o'>)</span>,
  growth <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/percent.html'>percent</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>0.3</span>, <span class='m'>0.3</span>, <span class='m'>0.1</span>, <span class='m'>0.15</span>, <span class='m'>0.15</span><span class='o'>)</span>, format <span class='o'>=</span> <span class='s'>"d"</span><span class='o'>)</span>,
  ready <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/formattable.html'>formattable</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>TRUE</span>, <span class='kc'>TRUE</span>, <span class='kc'>FALSE</span>, <span class='kc'>FALSE</span>, <span class='kc'>TRUE</span><span class='o'>)</span>, <span class='s'>"yes"</span>, <span class='s'>"no"</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>p</span></pre>
<pre class='chroma'>
<span class='c'>##   id name balance growth ready</span>
<span class='c'>## 1  1   A1  52,500    30%   yes</span>
<span class='c'>## 2  2   A2  36,150    30%   yes</span>
<span class='c'>## 3  3   B1  25,000    10%    no</span>
<span class='c'>## 4  4   B2  18,300    15%    no</span>
<span class='c'>## 5  5   C1   7,600    15%   yes</span></pre>

## Formatting tables in dynamic document

In a typical workflow of dynamic document production, [knitr](https://yihui.org/knitr/) and [rmarkdown](https://rmarkdown.rstudio.com/) are powerful tools to render documents with R code to different types of portable documents.

knitr is able to render an RMarkdown document (markdown document with R code chunks) to Markdown document. rmarkdown calls [pandoc](https://johnmacfarlane.net/pandoc) to render a markdown document to HTML web page. To put a table (`data.frame` in R) on the page, one may call [`knitr::kable`](https://rdrr.io/pkg/knitr/man/kable.html) to produce its markdown representation. By default the resulted table is in a plain theme with no additional formatting. However, in some cases, additional formatting may help clarify the information and make contrast of the data. This package provides functions to produce formatted tables in dynamic documents.

<pre class='chroma'>
<span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>
  id <span class='o'>=</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>10</span>,
  name <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Bob"</span>, <span class='s'>"Ashley"</span>, <span class='s'>"James"</span>, <span class='s'>"David"</span>, <span class='s'>"Jenny"</span>,
    <span class='s'>"Hans"</span>, <span class='s'>"Leo"</span>, <span class='s'>"John"</span>, <span class='s'>"Emily"</span>, <span class='s'>"Lee"</span><span class='o'>)</span>,
  age <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>28</span>, <span class='m'>27</span>, <span class='m'>30</span>, <span class='m'>28</span>, <span class='m'>29</span>, <span class='m'>29</span>, <span class='m'>27</span>, <span class='m'>27</span>, <span class='m'>31</span>, <span class='m'>30</span><span class='o'>)</span>,
  grade <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"C"</span>, <span class='s'>"A"</span>, <span class='s'>"A"</span>, <span class='s'>"C"</span>, <span class='s'>"B"</span>, <span class='s'>"B"</span>, <span class='s'>"B"</span>, <span class='s'>"A"</span>, <span class='s'>"C"</span>, <span class='s'>"C"</span><span class='o'>)</span>,
  test1_score <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>8.9</span>, <span class='m'>9.5</span>, <span class='m'>9.6</span>, <span class='m'>8.9</span>, <span class='m'>9.1</span>, <span class='m'>9.3</span>, <span class='m'>9.3</span>, <span class='m'>9.9</span>, <span class='m'>8.5</span>, <span class='m'>8.6</span><span class='o'>)</span>,
  test2_score <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>9.1</span>, <span class='m'>9.1</span>, <span class='m'>9.2</span>, <span class='m'>9.1</span>, <span class='m'>8.9</span>, <span class='m'>8.5</span>, <span class='m'>9.2</span>, <span class='m'>9.3</span>, <span class='m'>9.1</span>, <span class='m'>8.8</span><span class='o'>)</span>,
  final_score <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>9</span>, <span class='m'>9.3</span>, <span class='m'>9.4</span>, <span class='m'>9</span>, <span class='m'>9</span>, <span class='m'>8.9</span>, <span class='m'>9.25</span>, <span class='m'>9.6</span>, <span class='m'>8.8</span>, <span class='m'>8.7</span><span class='o'>)</span>,
  registered <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>TRUE</span>, <span class='kc'>FALSE</span>, <span class='kc'>TRUE</span>, <span class='kc'>FALSE</span>, <span class='kc'>TRUE</span>, <span class='kc'>TRUE</span>, <span class='kc'>TRUE</span>, <span class='kc'>FALSE</span>, <span class='kc'>FALSE</span>, <span class='kc'>FALSE</span><span class='o'>)</span>,
  stringsAsFactors <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span></pre>

Plain table:

<table>
<thead>
<tr>
<th style="text-align:right;">
id
</th>
<th style="text-align:left;">
name
</th>
<th style="text-align:right;">
age
</th>
<th style="text-align:left;">
grade
</th>
<th style="text-align:right;">
test1\_score
</th>
<th style="text-align:right;">
test2\_score
</th>
<th style="text-align:right;">
final\_score
</th>
<th style="text-align:left;">
registered
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Bob
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:left;">
C
</td>
<td style="text-align:right;">
8.9
</td>
<td style="text-align:right;">
9.1
</td>
<td style="text-align:right;">
9.00
</td>
<td style="text-align:left;">
TRUE
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Ashley
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
9.5
</td>
<td style="text-align:right;">
9.1
</td>
<td style="text-align:right;">
9.30
</td>
<td style="text-align:left;">
FALSE
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
James
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
9.6
</td>
<td style="text-align:right;">
9.2
</td>
<td style="text-align:right;">
9.40
</td>
<td style="text-align:left;">
TRUE
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
David
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:left;">
C
</td>
<td style="text-align:right;">
8.9
</td>
<td style="text-align:right;">
9.1
</td>
<td style="text-align:right;">
9.00
</td>
<td style="text-align:left;">
FALSE
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
Jenny
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:right;">
9.1
</td>
<td style="text-align:right;">
8.9
</td>
<td style="text-align:right;">
9.00
</td>
<td style="text-align:left;">
TRUE
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
Hans
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:right;">
9.3
</td>
<td style="text-align:right;">
8.5
</td>
<td style="text-align:right;">
8.90
</td>
<td style="text-align:left;">
TRUE
</td>
</tr>
<tr>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
Leo
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:right;">
9.3
</td>
<td style="text-align:right;">
9.2
</td>
<td style="text-align:right;">
9.25
</td>
<td style="text-align:left;">
TRUE
</td>
</tr>
<tr>
<td style="text-align:right;">
8
</td>
<td style="text-align:left;">
John
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
9.9
</td>
<td style="text-align:right;">
9.3
</td>
<td style="text-align:right;">
9.60
</td>
<td style="text-align:left;">
FALSE
</td>
</tr>
<tr>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
Emily
</td>
<td style="text-align:right;">
31
</td>
<td style="text-align:left;">
C
</td>
<td style="text-align:right;">
8.5
</td>
<td style="text-align:right;">
9.1
</td>
<td style="text-align:right;">
8.80
</td>
<td style="text-align:left;">
FALSE
</td>
</tr>
<tr>
<td style="text-align:right;">
10
</td>
<td style="text-align:left;">
Lee
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:left;">
C
</td>
<td style="text-align:right;">
8.6
</td>
<td style="text-align:right;">
8.8
</td>
<td style="text-align:right;">
8.70
</td>
<td style="text-align:left;">
FALSE
</td>
</tr>
</tbody>
</table>

Formatted table with the following visualizations:

-   Ages are rendered in gradient.
-   All A grades are displayed in green bold.
-   `test1_score` and `test2_score` are indicated by horizontal bars and are background-colorized: white (low score) to pink (high score)
-   `final_score` shows score and ranking. Top 3 are green, and others are gray.
-   `registered` texts are transformed to an icon and yes/no text.

<pre class='chroma'>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://renkun-ken.github.io/formattable/'>formattable</a></span><span class='o'>)</span>

<span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/formattable.html'>formattable</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  age <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/color_tile.html'>color_tile</a></span><span class='o'>(</span><span class='s'>"white"</span>, <span class='s'>"orange"</span><span class='o'>)</span>,
  grade <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/formatter.html'>formatter</a></span><span class='o'>(</span><span class='s'>"span"</span>, style <span class='o'>=</span> <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>x</span> <span class='o'>==</span> <span class='s'>"A"</span>,
    <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/style.html'>style</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"green"</span>, font.weight <span class='o'>=</span> <span class='s'>"bold"</span><span class='o'>)</span>, <span class='kc'>NA</span><span class='o'>)</span><span class='o'>)</span>,
  <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/area.html'>area</a></span><span class='o'>(</span>col <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>test1_score</span>, <span class='nv'>test2_score</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>~</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/normalize_bar.html'>normalize_bar</a></span><span class='o'>(</span><span class='s'>"pink"</span>, <span class='m'>0.2</span><span class='o'>)</span>,
  final_score <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/formatter.html'>formatter</a></span><span class='o'>(</span><span class='s'>"span"</span>,
    style <span class='o'>=</span> <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/style.html'>style</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='o'>-</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>&lt;=</span> <span class='m'>3</span>, <span class='s'>"green"</span>, <span class='s'>"gray"</span><span class='o'>)</span><span class='o'>)</span>,
    <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://rdrr.io/r/base/sprintf.html'>sprintf</a></span><span class='o'>(</span><span class='s'>"%.2f (rank: %02d)"</span>, <span class='nv'>x</span>, <span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='o'>-</span><span class='nv'>x</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>,
  registered <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/formatter.html'>formatter</a></span><span class='o'>(</span><span class='s'>"span"</span>,
    style <span class='o'>=</span> <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/style.html'>style</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>x</span>, <span class='s'>"green"</span>, <span class='s'>"red"</span><span class='o'>)</span><span class='o'>)</span>,
    <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/icontext.html'>icontext</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>x</span>, <span class='s'>"ok"</span>, <span class='s'>"remove"</span><span class='o'>)</span>, <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>x</span>, <span class='s'>"Yes"</span>, <span class='s'>"No"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>
<span class='o'>)</span><span class='o'>)</span></pre>

![formattable](formattable.png)

**The icon set used in the table is by [GLYPHICONS.com](https://GLYPHICONS.com) and included in [Bootstrap](https://getbootstrap.com/docs/3.4/components/#glyphicons).**

## `htmlwidget` conversion in interactive environments

`formattable` will automatically convert to an `htmlwidget` when in an [`interactive()`](https://rdrr.io/r/base/interactive.html) context such as the console or RStudio IDE. If you would like to avoid this conversion and see the `html` table output, please use [`format_table()`](https://renkun-ken.github.io/formattable/reference/format_table.html) that calls [`knitr::kable()`](https://rdrr.io/pkg/knitr/man/kable.html) with formatters or call [`format()`](https://rdrr.io/r/base/format.html) with the `formattable data.frame` object.

## License

This package is under [MIT License](https://opensource.org/licenses/MIT).
