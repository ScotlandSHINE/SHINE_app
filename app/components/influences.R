influences_ui <- function(id = "influences") {
  ns <- NS("influences")
  
  fluidPage(style = "display: flex;",
            
            mainPanel(
              id = ns("main-panel"), class = "app-panel col-lg-8",
              fluidPage(
                titlePanel(
                  "What influences the health and wellbeing of Scottish young people?"
                ),
                fluidRow(
                  style = "display: flex;
                  align-items: flex-start;
                  margin-top: 30px;
                  height: 190px;",
                  
                  column(6,
                         uiOutput(ns("exp_set"))),
                  # column(2, h2("Vs")),
                  column(6,
                         uiOutput(ns("out_set"))),
                )
              ),
              fluidRow(id = "graph-output",
              column(12,
                     fluidRow(plotOutput(
                       ns("plot"), height = "55vh"
                     ))
                     ))
            ))
  
}

influences_server <- function(id = "influences") {
  moduleServer(id, function(input, output, session) {
    output$exp_set <- renderUI({
      req(labs_cats)
      ns <- session$ns
      labs <- labs_cats %>%
        filter(cat == "exposure") %>%
        pull(lab)
      
      selectInput(ns("exposure"), "How does...",
                  choices = labs,
                  selectize = FALSE,
                  width = 300)
    })
    
    output$out_set <- renderUI({
      req(labs_cats)
      ns <- session$ns
      labs <- labs_cats %>%
        filter(cat == "outcome") %>%
        pull(lab)
      
      selectInput(ns("outcome"), "Affect...",
                  choices = labs,
                  selectize = FALSE,
                  width = 300)
    })
    
    output$exp_question <- renderText({
      req(input$exposure)
      labs_cats %>%
        filter(lab == input$exposure) %>%
        pull(question)
    })
    
    output$out_question <- renderText({
      req(input$exposure)
      labs_cats %>%
        filter(lab == input$outcome) %>%
        pull(question)
    })
    
    
    output$plot <- renderPlot({
      req(input$exposure, input$outcome)
      exposure <- filter(labs_cats, lab == input$exposure)
      outcome <- filter(labs_cats, lab == input$outcome)
      
      chart_data <- influences_data %>%
        select(exposure$variable, outcome$variable) %>%
        filter(across(everything(), ~ !is.na(.x)))
      

      
      base_lab <- levels(chart_data[[outcome$variable]])[[2]]
      
       chart_data %>%
          group_by(!!sym(exposure$variable)) %>% 
          mutate(denom = n()) %>% 
          group_by(!!sym(exposure$variable), !!sym(outcome$variable)) %>% 
          count() %>% 
          group_by(!!sym(exposure$variable)) %>% 
          mutate(denom = sum (n),
                prop =  n / denom,
                perc_label = paste0(round(100 * prop, 0),
                                    "%")) %>%
         mutate(text_y = abs(as.numeric(!!sym(outcome$variable) == levels(!!sym(outcome$variable))[[1]]) - prop/2)) %>% 
         filter(!!sym(outcome$variable) == base_lab) %>% 
          ggplot(aes_string(exposure$variable, "prop")) +
            geom_bar(stat = "identity",
                     fill = global_excel_colour) +
            theme(legend.position = "none",
                  panel.grid = element_blank()) +
            scale_x_discrete(str_wrap(exposure$question, 20)) +
            scale_y_continuous(str_wrap(
              paste0(
                "How many people say \"",
                base_lab,
                "\""
              ),
              700
            ),
            labels = percent_format(accuracy = 1),
            breaks = c(0, 0.5, 1),
            minor_breaks = seq(0, 1, 0.1),
            limits = c(0,1)) +
            geom_text(aes(y = text_y, label = perc_label),
                      colour = "#f5f5f5",
                      size = 15) +
            theme(axis.title.y = element_text(angle = 0,vjust = 0.5),
                  panel.grid.major.x = element_line(colour = "darkgrey", size = 1.2),
                  panel.grid.minor.x = element_line(colour = "grey")) +
         coord_flip()

       
    }) %>% bindCache(input$exposure, input$outcome, input$chart_type)
    
  })
}

influences_app <- function() {
  ui <- tagList(tags$style(sass::sass(
    sass::sass_file("app/styles/shine_app.scss")
  )),
  influences_ui())
  
  server <- function(input, output, session) {
    influences_server()
  }
  shinyApp(ui, server, options = list(appDir = "app"))
}

influences_lp_box <- lp_main_box(
  title_box = "What influences health and wellbeing?",
  description = "What things might influence how healthy Scottish young people feel?",
  image_name = "influences",
  button_name = "influences"
)

list(influences_ui, influences_server, influences_lp_box)
