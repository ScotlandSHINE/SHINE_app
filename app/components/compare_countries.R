compare_countries_ui <- function(id = "compare_countries") {
  ns <- NS("compare_countries")
  
  fluidPage(style = "display: flex;",
            
            mainPanel(id = "main-panel",
                      fluidPage(
                        titlePanel("How does Scotland compare with other countries?"),
                        fluidRow( 
                          style = "display: flex; align-items: flex-end",
                          column(12,
                                 uiOutput(ns("var_sel"))),
                        ),
                        fluidRow(class = "question",
                            textOutput(ns("description"))),
                        fluidRow(plotOutput(ns("plot"), height = "55vh"))
                      )))
  
} 

compare_countries_server <- function(id = "compare_countries") {
  moduleServer(id, function(input, output, session) {
    
    output$var_sel <- renderUI({
      req(compare_countries)
      ns <- session$ns
      selectInput(
        ns("select_var"),
        "Select a variable to compare:",
        choices = names(compare_countries),
        width = "100%"
      )
    })
    
    comparison <- reactive({compare_countries[[input$select_var]]})
    
    output$description <- renderText({
      req(input$select_var, comparison())
      comparison()$description
    })
    
    output$plot <- renderPlot({
      req(input$select_var, comparison())
      
      
    comparison()$data %>%
      mutate(sco = ifelse(country_region == "GB-SCT", "Scotland", NA)) %>% 
      filter(age_grp == "15YO", sex == "Boys") %>%
      left_join(country_codes,
                by = c("country_region" = "code")) %>%
      ggplot(aes(x = value, y = "")) +
      stat_summary(
        fun.data = function(t) {
          tibble(
            middle = median(t),
            ymin = min(t),
            ymax = max(t),
            lower = ymin,
            upper = ymax
          )
        },
        geom = "boxplot",
        width = 0.5
      ) +
      geom_point(aes(shape = sco), size = 3) +
      geom_text_repel(aes(label = sco), nudge_y = 0.1, box.padding = 2, size = pts(16), point.padding = 1) +
      scale_shape_manual(values = 18) +
      theme(legend.position = "none",
            axis.title.y = element_blank(),
            # plot.margin = margin(0, 10, 0, 10),
            panel.grid.major.y = element_blank()
            ) +
      scale_x_continuous(comparison()$title, labels = percent_format(accuracy = 1, scale = 1), expand = expansion(add = c(5, 2))) +
      stat_summary(
        fun.data = function(t) {
          tibble(
            y = c(min(t), median(t), max(t)),
            label = c(paste0("Lowest:\n2", min(t), "%"),
                      paste0("Middle:\n", median(t), "%"),
                      paste0("Highest:\n", max(t), "%"))
          )
        },
        geom = "text_repel",
        size = pts(16),
        vjust = 0,
        hjust = 0.5,
        nudge_x = 10
      ) 
    
    })
    
  })
}

compare_countries_app <- function() {
  ui <- tagList(
    tags$style(sass::sass(sass::sass_file("app/styles/shine_app.scss"))),
    compare_countries_ui())
  
  server <- function(input, output, session) {
    compare_countries_server()
  }  
  shinyApp(ui, server)
}


compare_countries_lp_box <- lp_main_box(
  "How does Scotland compare?",
  "compare_countries.png",
  "compare_countries",
  "How does Scotland compare with other countries in measures of health and behaviour?"
)


list(compare_countries_ui, compare_countries_server, compare_countries_lp_box)
