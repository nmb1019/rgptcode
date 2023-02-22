# rgptcoder
これはR studio用のAddinです。GPT-3のAPIを使って、自然言語で入力したコメントからRのコードを生成します。

This is an Addin for R Studio that uses the GPT-3 API to generate R code from comments inputted in natural language.
## インストールについて Installation
このアドインではjsonlite, httr, stringr, rstudioapi, shinyを使用します。これらをインストール後に、rgptcoderをインストールしてください。

This add-in uses __jsonlite, httr, stringr, rstudioapi, and shiny__. Please install these packages first, and then install __rgptcoder__.
```
install.packages("jsonlite")
install.packages("httr")
install.packages("stringr")
install.packages("rstudioapi")
install.packages("shiny")

install.packages("devtools")
devtools::install_github("nmb1019/rgptcoder")
```
