<!-- README.md is generated from README.Rmd on GitHub Actions: do not edit by hand -->

# formattable

<!-- badges: start -->

[![R build status](https://github.com/renkun-ken/formattable/workflows/rcc/badge.svg)](https://github.com/renkun-ken/formattable/actions) [![codecov.io](https://codecov.io/github/renkun-ken/formattable/coverage.svg?branch=master)](https://codecov.io/github/renkun-ken/formattable?branch=master) [![CRAN Version](https://www.r-pkg.org/badges/version/formattable)](https://cran.r-project.org/package=formattable)

<!-- badges: end -->

このパッケージは、ベクトルおよびデータフレームに書式を適用するために開発されました。これにより、データを「より簡単に」「よりリッチに」「より柔軟に」「できるだけ多くの情報を伝えるように」提示することができます。

## インストール

最新の開発バージョンを GitHub からインストールするには：

<pre class='chroma'>
<span class='c'># install.packages("devtools")</span>
<span class='nf'>devtools</span><span class='nf'>::</span><span class='nf'><a href='https://devtools.r-lib.org//reference/remote-reexports.html'>install_github</a></span><span class='o'>(</span><span class='s'>"renkun-ken/formattable"</span><span class='o'>)</span></pre>

[CRAN](https://cran.r-project.org/package=formattable) からインストールするには：

<pre class='chroma'>
<span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"formattable"</span><span class='o'>)</span></pre>

## イントロダクション

ベクトルはデータを保存するための基本的な単位です。データの中には、書式を適用することで、可読性が高まるものがあります。例えば、Rにおいて複数のパーセント値からなる数値ベクトルは通常の小数点形式で表示されます。このパッケージは、あらかじめ定義された書式のルールに従って、データ構造を作成するための関数を提供します。これにより、元のデータを保持したまま、表示の際には書式を適用することができます。

このパッケージでは`percent`, `comma`, `currency`, `accounting`, `scientific`など典型的な書式 を提供しています。これらのオブジェクトは、基本的には数値ベクトルですが、あらかじめ定義された書式ルールとパラメータを持っています。例えば、

<pre class='chroma'>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://renkun-ken.github.io/formattable/'>formattable</a></span><span class='o'>)</span>
<span class='nv'>p</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/percent.html'>percent</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>0.1</span>, <span class='m'>0.02</span>, <span class='m'>0.03</span>, <span class='m'>0.12</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>p</span></pre>
<pre class='chroma'>
<span class='c'>## [1] 10.00% 2.00%  3.00%  12.00%</span></pre>

このパーセントベクトルは、通常の数値ベクトルと違いはありません。ただし、コンソール上に表示したときに、パーセントで表示されます。四則演算や基本関数の適用を行っても、この書式は保持されます。

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

上で見た関数は、[`formattable()`](https://renkun-ken.github.io/formattable/reference/formattable.html) 関数でできることの特別なケースです。[`formattable()`](https://renkun-ken.github.io/formattable/reference/formattable.html) を使えば、`numeric`, `logical`, `factor`, `Date`, `data.frame` などの幅広いクラスのオブジェクトに対して、高度にカスタマイズされた書式を適用することができます。典型的なデータフレームは、列単位で[`formattable()`](https://renkun-ken.github.io/formattable/reference/formattable.html) を適用することによって、より読みやすくなるでしょう。例えば、

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

## 動的ドキュメント中のテーブル(表)の書式

動的ドキュメント生成の典型的なワークフローの中で、[knitr](https://yihui.org/knitr/) と [rmarkdown](https://rmarkdown.rstudio.com/) は、R コードを含むドキュメントを異なるタイプのドキュメントに変換するための強力なツールです。

knitr は、RMarkdown ドキュメントを Markdown ドキュメントに変換することができます。rmarkdown は、[pandoc](https://johnmacfarlane.net/pandoc) を使って、markdowon ドキュメントを HTML ウェブページに変換します。これらのドキュメント中に、R の `data.frame` をテーブル(表)として置きたいときは、[`knitr::kable`](https://rdrr.io/pkg/knitr/man/kable.html) 関数を使って markdown 形式に変換することができます。 kable関数で生成されたテーブルは、デフォルトでは書式が適用されていません。ですが、書式を追加することにより、情報が明確化され、データが対比しやすくなる場合があるでしょう。本パッケージは、動的ドキュメントにおいて書式を適用したテーブルを生成するための関数を提供します。

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

何もしない場合、次のようなテーブルが表示されます：

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

次のようにテーブルをフォーマットします：

-   年齢(age)はグラデーションで表示する。
-   A評価(grade)は緑の太字で表示する。
-   `test1_score` と `test2_score` は得点によってピンクの横棒で示される(長いほど高得点)。
-   `final_score` はスコアと順位(rank)を表示する。トップ3は緑、それ以外はグレーの文字。
-   `registered` はアイコン付きの Yes/No に変換する。

<pre class='chroma'>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://renkun-ken.github.io/formattable/'>formattable</a></span><span class='o'>)</span>

<span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/formattable.html'>formattable</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  age <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/color_tile.html'>color_tile</a></span><span class='o'>(</span><span class='s'>"white"</span>, <span class='s'>"orange"</span><span class='o'>)</span>,
  grade <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/formatter.html'>formatter</a></span><span class='o'>(</span><span class='s'>"span"</span>,
    style <span class='o'>=</span> <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>x</span> <span class='o'>==</span> <span class='s'>"A"</span>, <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/style.html'>style</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"green"</span>, font.weight <span class='o'>=</span> <span class='s'>"bold"</span><span class='o'>)</span>, <span class='kc'>NA</span><span class='o'>)</span><span class='o'>)</span>,
  test1_score <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/normalize_bar.html'>normalize_bar</a></span><span class='o'>(</span><span class='s'>"pink"</span>, <span class='m'>0.2</span><span class='o'>)</span>,
  test2_score <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/normalize_bar.html'>normalize_bar</a></span><span class='o'>(</span><span class='s'>"pink"</span>, <span class='m'>0.2</span><span class='o'>)</span>,
  final_score <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/formatter.html'>formatter</a></span><span class='o'>(</span><span class='s'>"span"</span>,
    style <span class='o'>=</span> <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/style.html'>style</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='o'>-</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>&lt;=</span> <span class='m'>3</span>, <span class='s'>"green"</span>, <span class='s'>"gray"</span><span class='o'>)</span><span class='o'>)</span>,
    <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://rdrr.io/r/base/sprintf.html'>sprintf</a></span><span class='o'>(</span><span class='s'>"%.2f (rank: %02d)"</span>, <span class='nv'>x</span>, <span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='o'>-</span><span class='nv'>x</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>,
  registered <span class='o'>=</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/formatter.html'>formatter</a></span><span class='o'>(</span><span class='s'>"span"</span>,
    style <span class='o'>=</span> <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/style.html'>style</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>x</span>, <span class='s'>"green"</span>, <span class='s'>"red"</span><span class='o'>)</span><span class='o'>)</span>,
    <span class='nv'>x</span> <span class='o'>~</span> <span class='nf'><a href='https://renkun-ken.github.io/formattable/reference/icontext.html'>icontext</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>x</span>, <span class='s'>"ok"</span>, <span class='s'>"remove"</span><span class='o'>)</span>, <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>x</span>, <span class='s'>"Yes"</span>, <span class='s'>"No"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>
<span class='o'>)</span><span class='o'>)</span></pre>

![formattable](formattable.png)

**テーブルで使用されるアイコンセットは [GLYPHICONS.com](https://GLYPHICONS.com) によるものです。これは [Bootstrap](https://getbootstrap.com/docs/3.4/components/#glyphicons) に含まれています。**

## インタラクティブな環境における `htmlwidget` への自動変換

`formattable` オブジェクト は、コンソールや RStudio IDE などの [`interactive()`](https://rdrr.io/r/base/interactive.html) な状況では、自動的に `htmlwidget` オブジェクト へと変換されます。この変換を避けたい場合や、`markdown` 形式のテーブル出力を見たい場合は、[`format_table()`](https://renkun-ken.github.io/formattable/reference/format_table.html) 関数を使って下さい。この関数は、[`knitr::kable()`](https://rdrr.io/pkg/knitr/man/kable.html) に書式を適用して整形した状態で呼び出すことができます。もしくは、`formattable data.frame` オブジェクトに対しては [`as.character()`](https://rdrr.io/r/base/character.html) を呼び出して下さい。

## ライセンス

このパッケージは [MIT License](https://opensource.org/licenses/MIT) の下で公開されています。
