# Define UI for application that draws a histogram

shinyUI(
  navbarPage(
    id = "main_page",
    windowTitle = "Explore Scotland's SHINE project data",
    theme = bs_theme(version = 4),
    header = tags$head(
      tags$link(href = "shine_app.css", rel = "stylesheet", type = "text/css")
    ),
    title = div(class = "logo",
                tags$a(
                  href = "/",
                  img(class = "top-logo img-fluid", src = "images/cropped-180-with-isles.png")
                )),
    
    # Placeholder
    tabPanel("Home",
             
             mainPanel(width = 11,style="margin-left:4%; margin-right:4%",
               fluidRow(
                 h1("Check out our apps below to explore HBSC and SHINE data..."),
                 column(
                 6,
                 lp_main_box(
                   "Problematic social media use",
                   "prob_soc_med",
                   "prob_soc_med",
                   "What proportions of adoelscents report problematic social media use?"
                 )
               ))
             )),
    
    navbarMenu("Explore apps... ",
               
               tabPanel("Social media use",
                        soc_med_ui,))
  )
)
