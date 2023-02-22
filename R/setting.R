#' Set OpenAI API Key and Output Language
#'
#' This function sets the OpenAI API key and output language to be used by other functions in the package.
#' The OpenAI API key is required for authentication when making requests to the OpenAI API. The output
#' language determines the language in which the results will be returned by the OpenAI API.
#'
#' @name setting
#' @export
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

