shinyUI(
  navbarPage(
    id = "main_page",
    windowTitle = "Explore Scotland's SHINE project data",
    theme = bs_theme(version = 4),
    header = tags$head(
      tags$link(href = "shine_app.css", rel = "stylesheet", type = "text/css"),
      tags$link(rel = "shortcut icon", href = "favicon_shine.ico"),
    ),
    title = div(class = "logo",
                actionLink(
                  inputId = "home_logo",
                  label = img(class = "top-logo img-fluid", src = "images/SHINE Final logo@300x.png")
                )),
    
    # Home page - layout of panels
    tabPanel("Home",
             
             mainPanel(
               id = "main-panel",
               fluidRow(h1(
                 "Check out our apps below to explore HBSC and SHINE data..."
               )),
               fluidRow(column(6,
                               soc_med_lpBox),
                        column(6,
                               vars_by_age_lpBox))
             )),
    
    # All apps nested in single menu (so as not to distract from screen)
    navbarMenu("Explore apps... ",
               
               tabPanel("Social media use",
                        soc_med_ui(), ),
               tabPanel("Young people's health",
                        vars_by_age_ui()))
    
    # Adds a debug button to navbar
    # tags$script(
    #   HTML(
    #     "$('.navbar > .container-fluid').append(
    #     '<button class=\"btn btn-default action-button btn-primary shiny-bound-input\" id=\"debug\" type=\"button\">Debug</button>')"
    #   )
    # )
  )
)
