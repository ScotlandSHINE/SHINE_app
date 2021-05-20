soc_med_ui <- function(id = "soc_med") {
  
  ns <- NS(id)
  
  fluidPage(titlePanel("App example 1"),
            sidebarLayout(sidebarPanel(
              selectInput(
                ns("sex_soc"),
                "Sex to compare across",
                choices = c("Male", "Female"),
                selected = "Male"
              )
            ),
            
            mainPanel(plotOutput(
              ns("soc_med_use_bar"),
            ))))
}


soc_med_server <- function(id = "soc_med") {
  moduleServer(id, function(input, output, session) {
    
    output$soc_med_use_bar <- renderPlot({
      sex_choice <- str_to_upper(input$sex_soc)

      prob_soc_med %>%
        filter(country == "GB-SCT",
               # sex == sex_choice,
               ) %>%
        ggplot(aes(age_grp_2, value, fill = sex)) +
        geom_bar(stat = "identity", position = "dodge") +
        scale_y_continuous("Proportion of young people who are problematic users of social media",
                           labels = scales::label_percent(scale = 1)) +
        scale_x_discrete("Age group",
                         labels = c("11 year-olds", "13 year-olds", "15 year-olds")) +
        scale_fill_manual(values = c("#ff44cc", "#2266ee"))
      
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

soc_med_lpBox <- lp_main_box(
  title_box  = "Problematic social media use",
  image_name = "prob_soc_med",
  button_name  = "prob_soc_med",
  description  = "What proportions of adoelscents report problematic social media use?"
)

list(soc_med_ui, soc_med_server, soc_med_lpBox)

