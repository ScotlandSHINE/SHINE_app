shinyUI(
  navbarPage(
    id = "main_page",
    windowTitle = "Explore Scotland's SHINE project data",
    theme = bs_theme(version = 4),
    header = tags$head(
      tags$link(href = "shine_app.css", rel = "stylesheet", type = "text/css"),
      tags$link(rel = "shortcut icon", href = "favicon_shine.ico"),
      tags$script('
                                var dimension = [0, 0];
                                $(document).on("shiny:connected", function(e) {
                                    win_width = window.innerWidth;
                                    Shiny.onInputChange("compare_countries-win_width", win_width);
                                });
                                $(window).resize(function(e) {
                                    win_width = window.innerWidth;
                                    Shiny.onInputChange("compare_countries-win_width", win_width);
                                });
                            ')
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
                 fluidRow(class = "lp-row", column(6, class = "lp-element",
                                 vars_by_age_lp_box),
                          column(6, class = "lp-element",
                                 influences_lp_box)),
                 fluidRow(class = "lp-row", column(6, class = "lp-element",
                                 time_changes_lp_box),
                          column(6, class = "lp-element",
                                 compare_countries_lp_box))
               )),
      # All apps nested in single menu (so as not to distract from screen)
      navbarMenu(
        tags$span("Explore apps... "),
        
        icon = icon("navbar", "fa-bars"),
        
        tabPanel("Young people's health",
                 vars_by_age_ui()),
        tabPanel("Influences on health",
                 influences_ui()),
        tabPanel("Changes over time",
                 time_changes_ui()),
        tabPanel("Comparing with other countries",
                 compare_countries_ui())
        
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
