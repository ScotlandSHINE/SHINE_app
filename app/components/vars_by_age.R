vars_by_age_ui <- function(id = "vars_by_age") {
  ns <- NS("vars_by_age")
  
  fluidPage(
    fluidRow(
    selectInput(ns("select_var"), "Select a variable to compare:", choices = "Loading...")
  ),
  fluidRow(
    plotOutput(ns("plot"))
  )
  )
} 

vars_by_age_server <- function(id = "vars_by_age") {
  moduleServer(id, function(input, output, session) {
    
      updateSelectInput(
        inputId = "select_var",
        choices = names(vars_by_age)
      )
    
    df_ready <- reactive({vars_by_age[[input$select_var]]})
    
    
    output$plot <- renderPlot({
      req(df_ready())
      vars_by_age[[input$select_var]] %>% 
        filter(Age != "All") %>% 
        pivot_longer(-Age, names_to = "Gender", values_to = "Percentage") %>% 
        ggplot(aes(Age, Percentage, fill = Gender)) +
        geom_bar(stat = "identity", position = "dodge") +
        scale_fill_manual(values = c("Girls" = "#ff44cc","Boys" = "#2266ee"))
    
    })
    
  })
}

vars_by_age_app <- function() {
  ui <- tagList(
    tags$style(sass::sass(sass::sass_file("app/styles/shine_app.scss"))),
    vars_by_age_ui())
  
  server <- function(input, output, session) {
    vars_by_age_server()
  }  
  shinyApp(ui, server)
}

vars_by_age_lpBox <- lp_main_box(
  title_box = "How are Scotland’s young people doing?",
  description = "How did Scottish young people answer these questions about their health, excercise and how well they're doing?",
  button_name = "vars_by_age",
  image_name = "vars_by_age.png"
  )


list(vars_by_age_ui, vars_by_age_server, vars_by_age_lpBox)