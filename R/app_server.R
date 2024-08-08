#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
#' 

app_server <- function(input, output, session) {
  sever::sever()
  # Home
  callModule(mod_home_module1_server, "home_module1_ui_1")

  observeEvent(input$toAwesome00, {
    updatebs4TabItems(session = session, inputId = "tabs", selected = "home")
  })

  observeEvent(input$toAwesome11, {
    updatebs4TabItems(session = session, inputId = "tabs", selected = "Data")
  })

  observeEvent(input$toAwesome22, {
    updatebs4TabItems(session = session, inputId = "tabs", selected = "modelo")
  })

  observeEvent(input$toAwesome33, {
    updatebs4TabItems(session = session, inputId = "tabs", selected = "valueboxes")
  })

  # Import Data
  data <- callModule(mod_import_dt_server, "import_dt_ui_1")
  data

  # Descriptives
  mod_descrip_scatter_server("descrip_scatter_1", data = data, plot = 1)
  mod_descrip_boxplot_server("descrip_boxplot_1", data = data, plot = 2)

  
  # About
  callModule(mod_about_server, "about_ui_1")
}
