time_changes_ui <- function(id = "time_changes") {
  ns <- NS("time_changes")
  fluidPage(style = "display: flex;",
            
            mainPanel(id = ns("main-panel"), class = "app-panel col-xl-8",
                      fluidPage(
                        class = "cont-panel",
                        titlePanel("What's changed for Scotland's young people?"),
                        fluidRow(
                          style = "display: flex; align-items: flex-end",
                          column(12,
                                 uiOutput(ns("var_sel")))
                          )
                        ),
                        # div(class = "question",
                        #     textOutput(ns("question"))),
                      div(class = "question",
                          textOutput(ns("question"))),
                        fluidRow(style = "min-height: 50vh", plotlyOutput(ns("plot"), height = "60vh")),
                      data_sources
                      ))
} 

time_changes_server <- function(id = "time_changes") {
  moduleServer(id, function(input, output, session) {
    
    output$var_sel <- renderUI({
      req(time_changes)
      ns <- session$ns
      selectInput(ns("select_var"), 
                     "Select a health topic to compare across time:",
                     choices = names(time_changes),
                  width = "100%",
                  selectize = FALSE)
    })
    
    df <- reactive({
      req(input$select_var)
      time_changes[[input$select_var]]$data
    })
    
    output$question <- reactive({
      req(input$select_var)
      q <- time_changes[[input$select_var]]$question
      a <- time_changes[[input$select_var]]$axis_label
      
      paste0(q, " (", a, ")")
    })
    
    
    output$plot <- renderPlotly({
      req(df())
      
      
      gg_out <- df() %>% 
        pivot_longer(Boys:Girls, names_to = "Gender", values_to = "perc") %>% 
        mutate(text = paste0("Proportion of ", tolower(Gender), "\nin ", Year, ": ", perc, "%")) %>% 
        ggplot(aes(Year, perc, colour = Gender, group = Gender, text = text)) +
        geom_point() +
        geom_line() +
        scale_y_continuous("Percentage", labels = percent_format(scale = 1, accuracy = 1), limits = c(0, NA),
                           expand = expansion(add = c(0, 10)), breaks = seq(0, 100, 10)) +
        scale_colour_manual(values = c("Girls" = global_girls_colour,
                                     "Boys" = global_boys_colour,
                                     "Good" = global_good_colour,
                                     "Excellent" = global_excel_colour)) +
        theme(
          text = element_text(size = 14),
          legend.key.size = unit(30, "pt"),
          legend.text = element_text(size = 18),
          axis.title.y = element_text(size = 18),
          axis.title.x = element_text(size = 18),
        )
      
      ggpl <- ggplotly(gg_out, tooltip = "text") %>%
        config(displayModeBar = FALSE)  %>%
        layout(
          xaxis = list(fixedrange = TRUE),
          yaxis = list(fixedrange = TRUE, title = list(standoff = 30)),
          margin = list(l = 100, b = 100)
          )
      
      ggpl 
      
    }) %>%
      bindCache(input$select_var)
    
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
