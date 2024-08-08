# Contains all the UI components, including the dashboard layout, sidebar, and main content areas.

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    bs4DashPage(
      title = "ECGO Dash",
      skin = NULL, 
      freshTheme = TRUE,
      preloader = NULL,
      options = NULL,
      fullscreen = TRUE,
      help = NULL, 
      dark = FALSE, 
      scrollToTop = TRUE,
      header = bs4DashNavbar(
        title = dashboardBrand(
          title = "ECGO Dash",
          color = "white",
          href = "https://ecgoevmoto.com/",
          image = "www/logo.png",
          opacity = 2
        ),
        status = "white",
        fixed = F,
        "PT Green City Traffic",
        # HTML("<script type='text/javascript' src='https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js' data-name='bmc-button' data-slug='dsciencelabs' data-color='#FFFFFF' data-emoji=''  data-font='Cookie' data-text='Buy MrBean a coffee' data-outline-color='#000' data-font-color='#000' data-coffee-color='#fd0' ></script>"),
        rightUi = bs4DropdownMenu(
          type = "messages",
          badgeStatus = "danger",
          href = "http://buymeacoffee.com/dsciencelabs",
          messageItem(
            from = "Bakti Siregar",
            message  = "Is there any questions for me?", 
            time = "today", image = "www/logo.png", 
            href = "http://buymeacoffee.com/dsciencelabs"
          )
        )
      ),
      
      # Sidebar
      sidebar = bs4DashSidebar(
        skin = "light",
        status = "success",
        elevation = 3,
        fixed = TRUE,
        bs4SidebarMenu(
          id = "tabs",
          bs4SidebarHeader("Menu"),
          bs4SidebarMenuItem("Home", 
                             tabName = "home", icon = shiny::icon("home", verify_fa = FALSE)),
          # Import data
          bs4SidebarMenuItem("Data", icon = shiny::icon("database"),
            startExpanded = F,
            bs4SidebarMenuItem(
              text = "Upload",
              tabName = "Data",
              icon = shiny::icon("file-upload", verify_fa = FALSE)
            ),
            bs4SidebarMenuItem(
              text = "Descriptives",
              tabName = "descriptives",
              icon = shiny::icon("chart-line")
            )
          ),
          
          # about
          bs4SidebarHeader("About"),
          bs4SidebarMenuItem(
            text = "info",
            tabName = "valueboxes",
            icon = shiny::icon("leaf")
          )
        )
      ),
      
      # body
      body = bs4DashBody(
        bs4TabItems(
          # chooseSliderSkin("Modern"),
          bs4TabItem(
            tabName = "home",
            mod_home_module1_ui("home_module1_ui_1")
          ),
          # Import data
          bs4TabItem(
            tabName = "Data",
            mod_import_dt_ui("import_dt_ui_1")
          ),
          bs4TabItem(
            tabName = "descriptives",
            HTML('<h1 style="font-weight: bold; color: #00a65a;">Descriptive Plots</h1>'),
            fluidRow(
              column(
                width = 6,
                mod_descrip_scatter_ui("descrip_scatter_1")
              ),
              column(
                width = 6,
                mod_descrip_boxplot_ui("descrip_boxplot_1")
              )
            )
          ),

          # About
          bs4TabItem(
            tabName = "valueboxes",
            mod_about_ui("about_ui_1")
          )
        )
      ),
      controlbar = bs4DashControlbar(
        skin = "light",
        # pinned = TRUE,
        br(),
        col_4(),
        col_4(
          h5("Go to:"),
          actionLink(
            inputId = "toAwesome00",
            label = "Home",
            icon = icon("home", verify_fa = FALSE)
          ),
          br(),
          actionLink(
            inputId = "toAwesome11",
            label = "Data",
            icon = icon("database")
          ),
          br(),
          actionLink(
            inputId = "toAwesome33",
            label = "About",
            icon = icon("chart-column", verify_fa = FALSE)
          ),
          br()
        ),
        col_4()
      ),
      footer = bs4DashFooter(
        fixed = TRUE,
        left = tagList(
          "v.1.0",
          HTML("&nbsp; &nbsp; &nbsp; &nbsp;"),
          a(
            href = "https://www.linkedin.com/in/dsciencelabs/",
            target = "_blank", "siregarbakti@gmail.com"
          )
        ),
        right = tagList(
          "@ ECGO EVMOTO 2024",
          HTML("&nbsp; &nbsp; &nbsp; &nbsp;") 
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www", app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "ECGO EVMOTO"
    ),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
    shinyjs::useShinyjs(),
    # shinyalert::useShinyalert(),
    rintrojs::introjsUI(),
    shinytoastr::useToastr(),
    waiter::use_waiter(),
    sever::useSever()
  )
}
