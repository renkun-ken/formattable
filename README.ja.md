# formattable

[![Linux Build Status](https://travis-ci.org/renkun-ken/formattable.png?branch=master)](https://travis-ci.org/renkun-ken/formattable) 
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/renkun-ken/formattable?svg=true)](https://ci.appveyor.com/project/renkun-ken/formattable)
[![codecov.io](http://codecov.io/github/renkun-ken/formattable/coverage.svg?branch=master)](http://codecov.io/github/renkun-ken/formattable?branch=master)
[![CRAN Version](http://www.r-pkg.org/badges/version/formattable)](http://cran.rstudio.com/web/packages/formattable)

このパッケージは、ベクトルおよびデータフレームに書式を適用するために開発されました。これにより、データを「より簡単に」「よりリッチに」「より柔軟に」「できるだけ多くの情報を伝えるように」提示することができます。

## インストール

最新の開発バージョンを GitHub からインストールするには：

```r
# install.packages("devtools")
devtools::install_github("renkun-ken/formattable")
```

[CRAN](http://cran.r-project.org/web/packages/formattable/index.html) からインストールするには：

```r
install.packages("formattable")
```

## イントロダクション

ベクトルはデータを保存するための基本的な単位です。データの中には、書式を適用することで、可読性が高まるものがあります。例えば、Rにおいて複数のパーセント値からなる数値ベクトルは通常の小数点形式で表示されます。このパッケージは、あらかじめ定義された書式のルールに従って、データ構造を作成するための関数を提供します。これにより、元のデータを保持したまま、表示の際には書式を適用することができます。

このパッケージでは`percent`, `comma`, `currency`, `accounting`, `scientific`など典型的な書式 を提供しています。これらのオブジェクトは、基本的には数値ベクトルですが、あらかじめ定義された書式ルールとパラメータを持っています。例えば、


```r
library(formattable)
p <- percent(c(0.1, 0.02, 0.03, 0.12))
p
```

```
## [1] 10.00% 2.00%  3.00%  12.00%
```

このパーセントベクトルは、通常の数値ベクトルと違いはありません。ただし、コンソール上に表示したときに、パーセントで表示されます。四則演算や基本関数の適用を行っても、この書式は保持されます。


```r
p + 0.05
```

```
## [1] 15.00% 7.00%  8.00%  17.00%
```

```r
max(p)
```

```
## [1] 12.00%
```


```r
balance <- accounting(c(1000, 500, 200, -150, 0, 1200))
balance
```

```
## [1] 1,000.00 500.00   200.00   (150.00) 0.00     1,200.00
```

```r
balance + 1000
```

```
## [1] 2,000.00 1,500.00 1,200.00 850.00   1,000.00 2,200.00
```

上で見た関数は、`formattable()` 関数でできることの特別なケースです。`formattable()` を使えば、`numeric`, `logical`, `factor`, `Date`, `data.frame` などの幅広いクラスのオブジェクトに対して、高度にカスタマイズされた書式を適用することができます。典型的なデータフレームは、列単位で`formattable()` を適用することによって、より読みやすくなるでしょう。例えば、

```r
p <- data.frame(
  id = c(1, 2, 3, 4, 5), 
  name = c("A1", "A2", "B1", "B2", "C1"),
  balance = accounting(c(52500, 36150, 25000, 18300, 7600), format = "d"),
  growth = percent(c(0.3, 0.3, 0.1, 0.15, 0.15), format = "d"),
  ready = formattable(c(TRUE, TRUE, FALSE, FALSE, TRUE), "yes", "no"))
p
```

```
##   id name balance growth ready
## 1  1   A1  52,500    30%   yes
## 2  2   A2  36,150    30%   yes
## 3  3   B1  25,000    10%    no
## 4  4   B2  18,300    15%    no
## 5  5   C1   7,600    15%   yes
```

## 動的ドキュメント中のテーブル(表)の書式

動的ドキュメント生成の典型的なワークフローの中で、[knitr](https://github.com/yihui/knitr) と [rmarkdown](http://rmarkdown.rstudio.com/) は、R コードを含むドキュメントを異なるタイプのドキュメントに変換するための強力なツールです。

knitr は、RMarkdown ドキュメントを Markdown ドキュメントに変換することができます。rmarkdown は、[pandoc](http://johnmacfarlane.net/pandoc) を使って、markdowon ドキュメントを HTML ウェブページに変換します。これらのドキュメント中に、R の `data.frame` をテーブル(表)として置きたいときは、`knitr::kable` 関数を使って markdown 形式に変換することができます。
kable関数で生成されたテーブルは、デフォルトでは書式が適用されていません。ですが、書式を追加することにより、情報が明確化され、データが対比しやすくなる場合があるでしょう。本パッケージは、動的ドキュメントにおいて書式を適用したテーブルを生成するための関数を提供します。


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

何もしない場合、次のようなテーブルが表示されます：


| id|name   | age|grade | test1_score| test2_score| final_score|registered |
|--:|:------|---:|:-----|-----------:|-----------:|-----------:|:----------|
|  1|Bob    |  28|C     |         8.9|         9.1|        9.00|TRUE       |
|  2|Ashley |  27|A     |         9.5|         9.1|        9.30|FALSE      |
|  3|James  |  30|A     |         9.6|         9.2|        9.40|TRUE       |
|  4|David  |  28|C     |         8.9|         9.1|        9.00|FALSE      |
|  5|Jenny  |  29|B     |         9.1|         8.9|        9.00|TRUE       |
|  6|Hans   |  29|B     |         9.3|         8.5|        8.90|TRUE       |
|  7|Leo    |  27|B     |         9.3|         9.2|        9.25|TRUE       |
|  8|John   |  27|A     |         9.9|         9.3|        9.60|FALSE      |
|  9|Emily  |  31|C     |         8.5|         9.1|        8.80|FALSE      |
| 10|Lee    |  30|C     |         8.6|         8.8|        8.70|FALSE      |

次のようにテーブルをフォーマットします：

* 年齢(age)はグラデーションで表示する。
* A評価(grade)は緑の太字で表示する。
* `test1_score` と `test2_score` は得点によってピンクの横棒で示される(長いほど高得点)。
* `final_score` はスコアと順位(rank)を表示する。トップ3は緑、それ以外はグレーの文字。
* `registered` はアイコン付きの Yes/No に変換する。


```r
library(formattable)

formattable(df, list(
  age = color_tile("white", "orange"),
  grade = formatter("span",
    style = x ~ ifelse(x == "A", style(color = "green", font.weight = "bold"), NA)),
  test1_score = normalize_bar("pink", 0.2),
  test2_score = normalize_bar("pink", 0.2),
  final_score = formatter("span",
    style = x ~ style(color = ifelse(rank(-x) <= 3, "green", "gray")),
    x ~ sprintf("%.2f (rank: %02d)", x, rank(-x))),
  registered = formatter("span", 
    style = x ~ style(color = ifelse(x, "green", "red")),
    x ~ icontext(ifelse(x, "ok", "remove"), ifelse(x, "Yes", "No")))
))
```

![formattable](./formattable.png?raw=true)

**テーブルで使用されるアイコンセットは [GLYPHICONS.com](http://GLYPHICONS.com) によるものです。これは [Bootstrap](http://getbootstrap.com/components/#glyphicons) に含まれています。**

## インタラクティブな環境における `htmlwidget` への自動変換

`formattable` オブジェクト は、コンソールや RStudio IDE などの `interactive()` な状況では、自動的に `htmlwidget` オブジェクト へと変換されます。この変換を避けたい場合や、`markdown` 形式のテーブル出力を見たい場合は、`format_table` 関数を使って下さい。この関数は、`knitr::kable` に書式を適用して整形した状態で呼び出すことができます。もしくは、`formattable data.frame` オブジェクトに対しては `as.character` を呼び出して下さい。

## ライセンス

このパッケージは [MIT License](http://opensource.org/licenses/MIT) の下で公開されています。
