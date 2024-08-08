#' import_dt UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_import_dt_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::box(
        title = tagList(shiny::icon("upload"), "Source"),
        solidHeader = FALSE,
        status = "success",
        maximizable = F,
        closable = F,
        width = 3,
        radioGroupButtons(
          inputId = ns("Id004"),
          choices = c("Example Data" = 1, "Import Data" = 2),
          status = "success",
          selected = 1
        ),
        conditionalPanel(
          condition = "input.Id004==1",
          h6("Use the example database to try the different modules"),
          ns = ns
        ),
        conditionalPanel(
          condition = "input.Id004==2",
          h6("Import external data preferably csv/txt files."),
          ns = ns
        )
      ),
      column(
        width = 3,
        conditionalPanel(
          condition = "input.Id004==2",
          ns = ns,
          bs4Dash::box(
            title = tagList(
              shiny::icon("file-upload", verify_fa = FALSE), "Import Data"
            ),
            solidHeader = FALSE,
            width = 12,
            status = "success",
            maximizable = T,
            closable = F,
            fileInput(
              inputId = ns("file1"),
              width = "100%",
              label = "Load your database",
              accept = c(
                "text/csv",
                "text/comma-separated-values",
                "text/tab-separated-values",
                "text/plain",
                ".csv",
                ".tsv", "xlsx"
              )
            ),
            helpText("Default max. file size is 100MB"),
            prettyCheckbox(
              inputId = ns("header"),
              label = "Include Header?",
              icon = icon("check"),
              outline = TRUE,
              fill = FALSE,
              shape = "square",
              animation = "tada",
              value = TRUE,
              status = "success"
            )
          )
        )
      ),
      column(
        width = 3,
        conditionalPanel(
          condition = "input.Id004==2",
          ns = ns,
          shinyjs::hidden(
            div(
              id = ns("when_file1"),
              bs4Dash::box(
                title = tagList(shiny::icon("wrench"), "Attributes"),
                solidHeader = FALSE,
                maximizable = T,
                closable = F,
                radioButtons(
                  inputId = ns("miss"),
                  label = "Missing value character: ",
                  choices = list("NA", "Empty", "Other"),
                  inline = T
                ),
                conditionalPanel(
                  condition = "input.miss=='Other'",
                  ns = ns,
                  textInput(ns("datamiss"),
                    label = "String",
                    width = "100%"
                  )
                ),
                selectInput(
                  inputId = ns("sep"),
                  label = "Cell separation character:",
                  choices = list(
                    Tab = "\t",
                    Comma = ",",
                    Semicolon = ";",
                    "Space" = " "
                  ),
                  selected = ";",
                  width = "100%"
                ),
                uiOutput(ns("oshet")),
                width = 12,
                status = "success"
              )
            )
          )
        )
      ),
      column(
        width = 3,
        conditionalPanel(
          condition = "input.Id004==2",
          ns = ns,
          shinyjs::hidden(
            div(
              id = ns("when_file2"),
              bs4Dash::box(
                title = tagList(shiny::icon("filter"), "Subset"),
                solidHeader = FALSE,
                maximizable = T,
                closable = F,
                prettyCheckbox(
                  inputId = ns("subset"),
                  label = "Select a data subset",
                  icon = icon("check"),
                  outline = TRUE,
                  fill = FALSE,
                  shape = "square",
                  animation = "tada",
                  value = FALSE,
                  status = "success"
                ),
                selectInput(
                  inputId = ns("varsubset"),
                  width = "100%",
                  label = tagList(
                    "Subset variable",
                    tags$a(icon("exclamation-circle", verify_fa = FALSE))
                  ),
                  choices = ""
                ),
                selectInput(
                  inputId = ns("levelessub"),
                  multiple = T,
                  width = "100%",
                  label = tagList(
                    "Which level?",
                    tags$a(icon("exclamation-circle", verify_fa = FALSE))
                  ),
                  choices = ""
                ),
                width = 12,
                status = "success"
              )
            )
          )
        )
      )
    ),
    fluidRow(
      bs4Dash::box(
        collapsed = F,
        maximizable = T,
        closable = F,
        shinycssloaders::withSpinner(
          DT::dataTableOutput(ns("data")),
          type = 5,
          color = "#28a745"
        ),
        width = 12,
        title = tagList(shiny::icon("file-import"), "Data"),
        status = "success",
        solidHeader = FALSE,
        collapsible = TRUE
      )
    ),
    br()
  )
}

#' import_dt Server Function
#'
#' @noRd
mod_import_dt_server <- function(input, output, session) {
  ns <- session$ns

  observe({
    shinyjs::show(
      id = "when_file1",
      animType = "fade",
      anim = TRUE
    )
    shinyjs::show(
      "when_file2",
      animType = "fade",
      anim = TRUE
    )
  }) %>%
    bindEvent(input$file1)

  output$oshet <- renderUI({
    inFile <- input$file1
    Ext <- tools::file_ext(inFile$datapath)
    req(input$file1, Ext == "xlsx" | Ext == "xls")

    selectInput(
      inputId = ns("sheet"),
      label = "Sheet Excel",
      choices = readxl::excel_sheets(inFile$datapath),
      width = "100%"
    )
  })

  # data --------------------------------------------------------------------

  DtReact <- reactive({
    input$ok2
    isolate({
      w$show()
      tryCatch(
        {
          datos <- dataqbms(studies = input$study, dt_studies = studies())
        },
        error = function(e) {
          shinytoastr::toastr_error(
            title = "Error:",
            conditionMessage(e),
            position = "bottom-full-width",
            showMethod = "slideDown",
            hideMethod = "hide",
            hideEasing = "linear"
          )
          w$hide()
        }
      )
      w$hide()
      if (!exists("datos")) datos <- NULL
      return(datos)
    })
  })


  dataset <- reactive({
    tryCatch(
      {
        data_react(
          file = input$file1,
          choice = input$Id004,
          header = input$header,
          sep = input$sep,
          miss = input$miss,
          string = input$datamiss,
          sheet = input$sheet,
          dataBMS = DtReact()
        )
      },
      error = function(e) {
        shinytoastr::toastr_error(
          title = "Error:",
          conditionMessage(e),
          position = "bottom-full-width",
          showMethod = "slideDown",
          hideMethod = "hide",
          hideEasing = "linear"
        )
      }
    )
  })

  # Subset data
  observe({
    updatePrettyCheckbox(
      session = session,
      inputId = "subset",
      value = F
    )
  }) %>%
    bindEvent(input$file1)

  observe({
    updateSelectInput(
      session,
      "varsubset",
      choices = names(dataset()),
      selected = "NNNNN"
    )
  })

  observe({
    toggle(
      "varsubset",
      anim = TRUE,
      time = 1,
      animType = "fade"
    )
    toggle("levelessub",
      anim = TRUE,
      time = 1,
      animType = "fade"
    )
  }) %>%
    bindEvent(input$subset)

  observe({
    if (input$varsubset != "") {
      lvl <- dataset()[, input$varsubset]
    } else {
      lvl <- ""
    }
    updateSelectInput(
      session,
      "levelessub",
      choices = lvl,
      selected = "NNNNN"
    )
  }) %>%
    bindEvent(input$varsubset, input$subset, ignoreInit = TRUE)

  dataset_sub <- reactive({
    data_subset(
      data = dataset(),
      subset = input$subset,
      variable = input$varsubset,
      level = input$levelessub
    )
  })

  output$data <- DT::renderDataTable({
    DT::datatable(
      {
        dataset_sub()
      },
      option = list(
        pageLength = 3,
        scrollX = TRUE,
        columnDefs = list(
          list(
            className = "dt-center",
            targets = 0:ncol(dataset_sub())
          )
        )
      ),
      filter = "top",
      selection = "multiple"
    )
  }) %>%
    bindEvent(dataset_sub())

  return(list(data = dataset_sub))
}

## To be copied in the UI
# mod_import_dt_ui("import_dt_ui_1")

## To be copied in the server
# callModule(mod_import_dt_server, "import_dt_ui_1")
