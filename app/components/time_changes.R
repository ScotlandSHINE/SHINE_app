time_changes_ui <- function(id = "time_changes") {
  ns <- NS("time_changes")
  fluidPage(style = "display: flex;",
            
            mainPanel(id = "main-panel",
                      fluidPage(
                        titlePanel("What's changed for Scotland's young people?"),
                        fluidRow(
                          style = "display: flex; align-items: flex-end",
                          column(12,
                                 uiOutput(ns("var_sel")))
                          )
                        ),
                        # div(class = "question",
                        #     textOutput(ns("question"))),
                        fluidRow(plotlyOutput(ns("plot"), height = "60vh"))
                      ))
} 

time_changes_server <- function(id = "time_changes") {
  moduleServer(id, function(input, output, session) {
    
    output$var_sel <- renderUI({
      req(time_changes)
      ns <- session$ns
      selectInput(ns("select_var"), 
                     "Select a variable to compare:",
                     choices = names(time_changes),
                  width = "100%")
    })
    
    df <- reactive({
      req(input$select_var)
      time_changes[[input$select_var]]$data
    })
    
    
    output$plot <- renderPlotly({
      req(df())
      
      
      gg_out <- df() %>% 
        pivot_longer(Boys:Girls, names_to = "Gender", values_to = "perc") %>% 
        mutate(text = paste0("Proportion of ", tolower(Gender), "\nin ", Year, ": ", perc, "%")) %>% 
        ggplot(aes(Year, perc, colour = Gender, group = Gender, text = text)) +
        geom_point() +
        geom_line() +
        scale_y_continuous("Percentage", labels = percent_format(scale = 1, accuracy = 1)) +
        scale_colour_manual(values = c("Girls" = global_girls_colour,
                                     "Boys" = global_boys_colour,
                                     "Good" = global_good_colour,
                                     "Excellent" = global_excel_colour))
      
      ggpl <- ggplotly(gg_out, tooltip = "text") %>%
        config(displayModeBar = FALSE) 
      ggpl 
      
    })
    
  })
}

time_changes_app <- function() {
  ui <- tagList(
    tags$style(sass::sass(sass::sass_file("app/styles/shine_app.scss"))),
    time_changes_ui())
  
  server <- function(input, output, session) {
    time_changes_server()
  }  
  shinyApp(ui, server)
}

time_changes_lp_box <- lp_main_box(
  "Changing rates",
  "time_changes.png",
  "time_changes",
  "What's changed for Scotland's young people in recent years?"
)


list(time_changes_ui, time_changes_server, time_changes_lp_box)
