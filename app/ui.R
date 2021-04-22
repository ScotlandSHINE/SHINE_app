shinyUI(
  navbarPage(
    id = "main_page",
    windowTitle = "Explore Scotland's SHINE project data",
    theme = bs_theme(version = 4),
    header = tags$head(
      tags$link(href = "shine_app.css", rel = "stylesheet", type = "text/css"),
      tags$link(rel="shortcut icon", href="favicon_shine.ico")
    ),
    title = div(class = "logo",
                tags$a(
                  href = "/",
                  img(class = "top-logo img-fluid", src = "images/SHINE Final logo@300x.png")
                )),
    
    # Home page - layout of panels
    tabPanel("Home",
             
             mainPanel(id = "main-panel",
                       style="max-width: 1140px",
               fluidRow(
                 h1("Check out our apps below to explore HBSC and SHINE data...")),
               fluidRow(
                 column(
                 6,
                 exec(lp_main_box, !!!soc_med_lpBox)
                 # lp_main_box(
                 #   "Problematic social media use",
                 #   "prob_soc_med",
                 #   "prob_soc_med",
                 #   "What proportions of adoelscents report problematic social media use?"
                 # )
               ))
             )),
    
    # All apps nested in single menu (so as not to distract from screen)
    navbarMenu("Explore apps... ",
               
               tabPanel("Social media use",
                        soc_med_ui("soc_med"),))
  )
)
