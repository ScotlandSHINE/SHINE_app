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
                  label =
                    span(
                      img(class = "top-logo img-fluid", src = "images/SHINE Final logo@300x.png"),
                      img(class = "top-logo img-fluid", src = "images/hbsc.png")
                    )
                )),
      # Home page - layout of panels
      tabPanel("Home",
               mainPanel(
                 id = "main-panel",
                 fluidRow(h1(
                   "Check out our apps below to explore HBSC and SHINE data..."
                 )),
                 fluidRow(class = "lp-row", column(6,
                                 vars_by_age_lp_box),
                          column(6,
                                 influences_lp_box)),
                 fluidRow(class = "lp-row", column(6,
                                 time_changes_lp_box),
                          column(6,))
               )),
      # All apps nested in single menu (so as not to distract from screen)
      navbarMenu(
        "Explore apps... ",
        
        tabPanel("Young people's health",
                 vars_by_age_ui()),
        tabPanel("Influences on health",
                 influences_ui()),
        tabPanel("Changes over time",
                 time_changes_ui())
        
      )

    # Adds a debug button to navbar
    # tags$script(
    #   HTML(
    #     "$('.navbar > .container-fluid').append(
    #     '<button class=\"btn btn-default action-button btn-primary shiny-bound-input\" id=\"debug\" type=\"button\">Debug</button>')"
    #   )
    # )
  )
  
)
