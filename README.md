# rgptcode
![This is an image](/rgptcode_sample.gif)

これはR studio用のAddinです。GPT-3のAPIを使って、自然言語で入力したコメントからRのコードを生成します。

This is an Addin for R Studio that uses the GPT-3 API to generate R code from comments inputted in natural language.
## インストールについて Installation
このアドインでは**jsonlite, httr, stringr, rstudioapi, shiny**を使用します。これらをインストール後に、**rgptcoder**をインストールしてください。

This add-in uses __jsonlite, httr, stringr, rstudioapi, and shiny__. Please install these packages first, and then install __rgptcode__.
```
install.packages("jsonlite")
install.packages("httr")
install.packages("stringr")
install.packages("rstudioapi")
install.packages("shiny")

install.packages("devtools")
devtools::install_github("nmb1019/rgptcode")
```
