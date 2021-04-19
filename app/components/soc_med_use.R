soc_med_ui <- function(id) {
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
              NS(id, "soc_med_use_bar")
            ))))
}


soc_med_serv <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$soc_med_use_bar <- renderPlot({
      sex_choice <- str_to_upper(input$sex_soc)
      
      
      prob_soc_med %>%
        filter(country == "GB-SCT",
               sex == sex_choice) %>%
        ggplot(aes(age_grp_2, value)) +
        geom_bar(stat = "identity",
                 fill = "#7722ff") +
        scale_y_continuous("Proportion of young people who are problematic users of social media") +
        scale_x_discrete("Age group",
                         labels = c("11 year-olds", "13 year-olds", "15 year-olds"))
      
    })
  }
  )
  
} 