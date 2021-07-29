influences_ui <- function(id = "influences") {
  ns <- NS("influences")
  
  fluidPage(style = "display: flex;",
            
            mainPanel(
              id = "main-panel",
              fluidPage(
                titlePanel(
                  "What influences the health and wellbeing of Scottish young people?"
                ),
                fluidRow(
                  style = "display: flex;
                  align-items: flex-start;
                  margin-top: 30px;
                  height: 190px;",
                  
                  column(5,
                         uiOutput(ns("exp_set")),
                         div(class = "question",
                             textOutput(
                               ns("exp_question")
                             ))),
                  column(2, h2("Vs")),
                  column(5,
                         uiOutput(ns("out_set")),
                         div(class = "question",
                             textOutput(
                               ns("out_question")
                             )), ),
                )
              ),
              fluidRow(id = "graph-output",
              column(10,
                     fluidRow(plotOutput(
                       ns("plot"), height = "60vh"
                     ))),
              column(2,
                     radioGroupButtons(
                       inputId = ns("chart_type"),
                       individual = TRUE,
                       direction = "vertical",
                       status = "chart-button",
                       choiceValues = c("show_mosaic",
                                        "show_circ",
                                        "show_sq"
                                        ),
                       selected = "show_mosaic",
                       choiceNames = c(
                                       HTML(read_file("www/images/button_mosaic.svg")),
                                       HTML(read_file("www/images/button_circ.svg")),
                                       HTML(read_file("www/images/button_sq.svg"))
                                       )
                     ),
                     ),
                       )
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
                  choices = labs)
    })
    
    output$out_set <- renderUI({
      req(labs_cats)
      ns <- session$ns
      labs <- labs_cats %>%
        filter(cat == "outcome") %>%
        pull(lab)
      
      selectInput(ns("outcome"), "Affect...",
                  choices = labs)
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
      
      if (input$chart_type == "show_mosaic") {
        chart_data %>% 
          ggplot() +
          geom_mosaic(aes(product(!!sym(exposure$variable)), fill = !!sym(outcome$variable)),
                      offset = 0.05) +
        theme(legend.position = "none",
              panel.grid = element_blank()) +
        xlab(exposure$lab) +
        ylab(outcome$lab) +
        scale_fill_manual(values = c("#2DAAE1",
                                       "#e30088"))
      } else {
        
       chart_data %>%
        ggplot(aes_string(exposure$variable, outcome$variable, colour = outcome$variable)) +
        stat_sum(shape = ifelse(input$chart_type == "show_circ", 16, 15)) +
        stat_sum(
          geom = "text",
          aes(
            label = scales::comma(after_stat(n), accuracy = 1),
            size = NULL,
            colour = NULL
          ),
          size = 15
        ) +
        scale_size_continuous(limits = c(1, 6000), range = c(1, 120)) +
        geom_vline(xintercept = 1.5, colour = "grey") +
        geom_hline(yintercept = 1.5, colour = "grey") +
        theme(legend.position = "none",
              panel.grid = element_blank()) +
        scale_x_discrete(exposure$lab) +
        scale_y_discrete(outcome$lab) +
        scale_colour_manual(values = c("#2DAAE1",
                                       "#e30088"))
      
      }
    })
    
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
  shinyApp(ui, server)
}

influences_lp_box <- lp_main_box(
  title_box = "What influences health and wellbeing?",
  description = "What things might influence how healthy Scottish young people feel?",
  image_name = "influences",
  button_name = "influences"
)

list(influences_ui, influences_server, influences_lp_box)
