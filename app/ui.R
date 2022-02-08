shinyUI(
  navbarPage(
    id = "main_page",
    windowTitle = "Explore Scotland's young people's health",
    theme = bs_theme(version = 4),
    header = tags$head(
      tags$link(href = "shine_app.css", rel = "stylesheet", type = "text/css"),
      tags$link(rel = "shortcut icon", href = "favicon_shine.ico"),
      includeHTML("google_analytics.html"),
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
                            '),
    tags$script(src = "https://cdn.plot.ly/plotly-latest.min.js"),
    tags$script(src = "https://raw.githubusercontent.com/rstudio/crosstalk/main/inst/www/js/crosstalk.min.js.map"),
    ),
    title = div(class = "logo",
                actionLink(
                  inputId = "home_logo",
                  label =
                    span(
                      img(class = "top-logo img-fluid", src = "images/SHINE Final logo@300x.png"),
                      img(class = "top-logo img-fluid", src = "images/hbsc_trans.png")
                    )
                )),
      # Home page - layout of panels
      tabPanel("Home",
               mainPanel(
                 class = "app-panel col-xl-8",
                 tags$div(id= "home_top",
                 fluidRow(h1(
                   "Check out our apps below to explore HBSC data..."
                 )),
                 fluidRow(class = "lp-row", column(6, class = "lp-element col-md-6",
                                 vars_by_age_lp_box),
                          column(6, class = "lp-element col-md-6",
                                 influences_lp_box)),
                 fluidRow(class = "lp-row", column(6, class = "lp-element col-md-6",
                                 time_changes_lp_box),
                          column(6, class = "lp-element col-md-6",
                                 compare_countries_lp_box)),
                 h3(id = "extra_head", HTML("More info about data used in these apps
                                            <i class='fas fa-arrow-down' style='font-size: 18pt'></i>"))
                          ),
                 data_sources
                 )),

    # All apps nested in single menu (so as not to distract from screen)
      navbarMenu(
        "Explore apps... ",
        
        icon = icon("bars", "fa-bars"),
        
        tabPanel("Young people's health",
                 vars_by_age_ui()),
        tabPanel("Influences on health",
                 influences_ui()),
        tabPanel("Changes over time",
                 time_changes_ui()),
        tabPanel("Comparing with other countries",
                 compare_countries_ui())
        
      ),
    
    navbarMenu(
      # id = "ext-links",
      # style = "margin-left: auto",
      "The project and data...",
      
      nav_item(a(href = "https://shine.sphsu.gla.ac.uk/", target = "_blank", "The SHINE project")),
      nav_item(a(href = "http://www.hbsc.org/", target = "_blank", "The HBSC survey")),
      nav_item(a(href = "http://www.hbsc.org/publications/international/", target = "_blank", "HBSC international report")),
      nav_item(a(href = "https://www.gla.ac.uk/hbscscotland", target = "_blank", "HBSC in Scotland"))
    )

    # Adds a debug button to navbar - DEV only!
    # ,tags$script(
    #   HTML(
    #     "$('.navbar > .container-fluid').append(
    #     '<button class=\"btn btn-default action-button btn-primary shiny-bound-input\" id=\"debug\" type=\"button\">Debug</button>')"
    #   )
    # )
    
    
    # Slight hack here - make landing page boxes respond to col-md-6 and snap to
    # single row at ~750 px rather than ~560
    ,tags$script(
      HTML(
        "$('.lp-element').removeClass('col-sm-6');
        $('.app-panel').removeClass('col-sm-8');
        "
      )
    )
  )
  
)
