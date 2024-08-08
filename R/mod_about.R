#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_about_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      
      column(
        width = 3,
        cardProfile(
          image = "www/logo.png",
          title = HTML(
            paste(
              bs4Badge("William Teng",
                       rounded = T,
                       position = "right",
                       color = "success"
              )
            )
          ),
          subtitle = HTML(
            paste(
              bs4Badge("CEO PT. Green City Traffic",
                       rounded = T,
                       position = "right",
                       color = "success"
              ),
              rep_br(1),
              "<a href='https://www.linkedin.com/in/william-teng-3bba19184/?originalSubdomain=id'>
              <i class='fab fa-linkedin' role='presentation' aria-label='linkedin icon'></i>
              </a>"
            )
          )
        )
      ),
      column(
        width = 3,
        cardProfile(
          image = "www/Bakti_Siregar.jpg",
          title = HTML(
            paste(
              bs4Badge("Bakti Siregar, M.Sc., CDS",
                rounded = T,
                position = "right",
                color = "success"
              )
            )
          ),
          subtitle = HTML(
            paste(
              bs4Badge("Data Scientist",
                rounded = T,
                position = "right",
                color = "success"
              ),
              rep_br(1),
              "<a href='https://www.linkedin.com/in/dsciencelabs/'>
              <i class='fab fa-linkedin' role='presentation' aria-label='linkedin icon'></i>
              </a>"
            )
          )
        )
      ),
      column(
        width = 3,
        cardProfile(
          image = "www/Hartono.png",
          title = HTML(
            paste(
              bs4Badge("Hartono",
                rounded = T,
                position = "right",
                color = "success"
              )
            )
          ),
          subtitle = HTML(
            paste(
              bs4Badge("CIB Production",
                rounded = T,
                position = "right",
                color = "success"
              ),
              rep_br(1),
              "<a href='https://www.linkedin.com/in/'>
              <i class='fab fa-linkedin' role='presentation' aria-label='linkedin icon'></i>
              </a>"
            )
          )
        )
      ),
      column(
        width = 3,
        cardProfile(
          image = "www/Justin.png",
          title = HTML(
            paste(
              bs4Badge("Justin",
                rounded = T,
                position = "right",
                color = "success"
              )
            )
          ),
          subtitle = HTML(
            paste(
              bs4Badge("Data Enginer",
                rounded = T,
                position = "right",
                color = "success"
              ),
              rep_br(1),
              "<a href='https://www.linkedin.com/in/d'>
              <i class='fab fa-linkedin' role='presentation' aria-label='linkedin icon'></i>
              </a>"
            )
          )
        )
      )
    ),
    br(),
    br(),
    fluidRow(
      col_3(
        img(src = "/www/Ecgo.png", width = "100%")
      )
    ),
    br(),
    bs4Card(
      title = div(icon("jsfiddle"), "Rsession"), width = 12,
      verbatimTextOutput(ns("Rsession")),
      br()
    )
  )
}

#' about Server Function
#'
#' @noRd
mod_about_server <- function(input, output, session) {
  ns <- session$ns
  output$Rsession <- renderPrint(
    print(utils::sessionInfo())
  )
}

## To be copied in the UI
# mod_about_ui("about_ui_1")

## To be copied in the server
# callModule(mod_about_server, "about_ui_1")
