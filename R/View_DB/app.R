# Load necessary packages
library(shiny)
library(RPostgres)
library(DT)

# Define PostgreSQL functions
connect_postgres <- function(dbname = "default_dbname", 
                             host = "localhost", 
                             port = 5432, 
                             user = "default_user", 
                             password) {
  conn <- RPostgres::dbConnect(
    RPostgres::Postgres(),
    dbname = dbname,
    host = host,
    port = port,
    user = user,
    password = password
  )
  return(conn)
}

list_tables <- function(conn) {
  tables <- RPostgres::dbListTables(conn)
  return(tables)
}

get_table_data <- function(conn, table) {
  query <- sprintf("SELECT * FROM %s", table)
  data <- RPostgres::dbGetQuery(conn, query)
  return(data)
}

# Define UI
ui <- fluidPage(
  titlePanel("PostgreSQL Data Viewer and Downloader"),
  
  fluidRow(
    column(3,
           textInput("dbname", "Database Name", value = "ebike"),
           textInput("host", "Host", value = "139.162.45.227"),
           textInput("port", "Port", value = 5432),
           textInput("user", "User", value = "ecgo-data"),
           passwordInput("password", "Password"),
           actionButton("connect", "Connect")
    ),
    column(3,
           selectInput("table", "Tables", choices = NULL),
           actionButton("load_table", "Load Table"),
           downloadButton("download_data", "Download Data")
    ),
    column(6,
           DTOutput("table_data")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  conn <- reactiveVal(NULL)
  
  observeEvent(input$connect, {
    # Connect to PostgreSQL
    conn(connect_postgres(input$dbname, input$host, input$port, input$user, input$password))
    showNotification("Connected to PostgreSQL")
    
    # Automatically list tables
    if (!is.null(conn())) {
      tables <- list_tables(conn())
      updateSelectInput(session, "table", choices = tables)
    }
  })
  
  table_data <- reactiveVal(NULL)
  
  observeEvent(input$load_table, {
    if (!is.null(conn())) {
      data <- get_table_data(conn(), input$table)
      table_data(data)
      output$table_data <- renderDT(data)
    }
  })
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste(input$table, "csv", sep = ".")
    },
    content = function(file) {
      data <- table_data()
      write.csv(data, file, row.names = FALSE)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)