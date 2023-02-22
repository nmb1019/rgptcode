#' Explain R code
#'
#' This function takes a string of R code and uses GPT-3 to provide a natural language explanation
#' of what the code does.
#'
#' @return A character string containing a natural language explanation of the R code.
#'
#' @name explainrcode
#' @title Explain R code

# 設定用ウィンドウ
setting <- function() {
  library(shiny)

  # 設定ファイルの作成（初回起動時）
  if (!file.exists("settings.rds")) {
    settings <- list(api_key = "", language = "日本語")
    saveRDS(settings, file = "settings.rds")
  }

  # UIの作成
  ui <- fluidPage(
    textInput("api_key_input", "OpenAI API Key", ""),
    selectInput("language_input", "Language", c("日本語", "English", "Chinese")),
    actionButton("save_btn", "Save")
  )

  # サーバーの作成
  server <- function(input, output, session) {
    # 初回起動時の設定を取得
    settings <- readRDS("settings.rds")

    # 入力ウィジェットの初期値を設定
    updateTextInput(session, "api_key_input", value = settings$api_key)
    updateSelectInput(session, "language_input", selected = settings$language)

    # 保存ボタンがクリックされたら設定を保存
    observeEvent(input$save_btn, {
      settings$api_key <- input$api_key_input
      settings$language <- input$language_input
      saveRDS(settings, file = "settings.rds")
      print("Your settings have been saved successfully.")
      shiny::stopApp()
    })
  }

  # アプリケーションの起動
  shiny::shinyApp(ui, server)
}

#' @export
explainrcode = function(){

  # OpenAI apiキーの確認
  if (file.exists("settings.rds")) {
    # 設定ファイルの読み込み
    settings <- readRDS("settings.rds")

    # 設定値の取得
    api_key <- settings$api_key
    language <- settings$language

    if (api_key == "") {
      setting()

      # 設定値の取得
      api_key <- settings$api_key
      language <- settings$language
    }
  } else {
    setting()

    # 設定値の取得
    api_key <- settings$api_key
    language <- settings$language
  }

  # 選択したコメントを取得
  capture <- rstudioapi::getActiveDocumentContext()

  # Find range
  range_start <- capture$selection[[1L]]$range$start[[1L]]
  range_end   <- capture$selection[[1L]]$range$end[[1L]]

  # Dump contents and use highlighted lines as names.
  selected_text <- capture$contents[range_start:range_end]

  if (api_key == ""){
    print("OpenAI apiキーを入力してください。")
    setting()
  } else {
    # APIに送信するためのリクエストの作成
    body <- list(prompt = paste("Explain the following r code in ", language, selected_text),
                 model = 'text-davinci-003',
                 temperature = 0.5,
                 max_tokens = 100,
                 n = 1,
                 stop = NULL,
                 frequency_penalty = 0,
                 presence_penalty = 0)

    # GPT-3 APIにリクエストを送信
    response <- httr::POST("https://api.openai.com/v1/completions"
                           , body = body
                           , httr::add_headers(.headers = c("content-type" = "application/json", "Authorization" =  paste("Bearer", "api_key")))
                           , encode = "json")

    # レスポンスの解析
    result <- jsonlite::fromJSON(httr::content(response, as = "text"))
    insert_text <- stringr::str_remove_all(result$choices$text, "\n")

    # 回答を1行下に挿入
    rstudioapi::insertText(paste(selected_text, "\n", insert_text))
  }
}

