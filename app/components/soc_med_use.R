soc_med_ui <- function(id = "soc_med") {
  fluidPage(titlePanel("App example 1"),
            sidebarLayout(sidebarPanel(
              selectInput(
                NS(id, "sex_soc"),
                "Sex to compare across",
                choices = c("Male", "Female"),
                selected = "Male"
              )
            ),
            
            mainPanel(plotOutput(
              NS(id, "soc_med_use_bar"),
            ))))
}


soc_med_server <- function(id = "soc_med") {
  moduleServer(id, function(input, output, session) {
    
    output$soc_med_use_bar <- renderPlot({
      sex_choice <- str_to_upper(input$sex_soc)

      prob_soc_med %>%
        filter(country == "GB-SCT",
               sex == sex_choice) %>%
        ggplot(aes(age_grp_2, value)) +
        geom_bar(stat = "identity") +
        scale_y_continuous("Proportion of young people who are problematic users of social media",
                           labels = scales::label_percent(scale = 1)) +
        scale_x_discrete("Age group",
                         labels = c("11 year-olds", "13 year-olds", "15 year-olds"))
      
    })
  }
  )
  
} 

soc_med_app <- function() {
  ui <- tagList(
    tags$style(sass::sass(sass::sass_file("app/styles/shine_app.scss"))),
    soc_med_ui())
  
  server <- function(input, output, session) {
    soc_med_server()
  }  
  shinyApp(ui, server)
}

list(soc_med_ui, soc_med_server)

