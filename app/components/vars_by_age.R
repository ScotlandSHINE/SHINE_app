vars_by_age_ui <- function(id = "vars_by_age") {
  ns <- NS("vars_by_age")
  fluidPage(style = "display: flex;",
            
            mainPanel(id = "main-panel",
                      fluidPage(
                        titlePanel("How are Scotland's young people doing?"),
                        fluidRow(
                          style = "display: flex; align-items: flex-end",
                          column(8,
                                 uiOutput(ns("var_sel"))),
                          column(
                            style = "align-self: center",
                            4,
                            checkboxInput(
                              ns("agegrp"),
                              "Split by age groups?",
                              value = TRUE,
                              width = "100%"
                            )
                          )
                        ),
                        div(class = "question",
                            textOutput(ns("question"))),
                        fluidRow(plotOutput(ns("plot"), height = "60vh"))
                      )))
}

vars_by_age_server <- function(id = "vars_by_age") {
  moduleServer(id, function(input, output, session) {
    output$var_sel <- renderUI({
      req(vars_by_age)
      ns <- session$ns
      selectInput(
        ns("select_var"),
        "Select a variable to compare:",
        choices = names(vars_by_age),
        width = "100%"
      )
    })
    
    df <- reactive({
      vars_by_age[[input$select_var]]
    })
    
    
    output$plot <- renderPlot({
      req(input$select_var, df())
      
      base_plot <- ggplot() +
        theme(panel.grid.major.x = element_blank()) +
        scale_y_continuous(name = df()$axis_label,
                           labels = percent_format(scale = 1, accuracy = 1)) +
        scale_fill_manual(values = c("Girls" = "#ff44cc",
                                     "Boys" = "#2266ee",
                                     "Good" = "#2DAAE1",
                                     "Excellent" = "#e30088"))
      
      if (input$agegrp) {
        plot_data <- df()$data %>%
          filter(Age != "All") %>%
          pivot_longer(Boys:Girls,
                       names_to = "Gender",
                       values_to = "Percentage")
      } else {
        plot_data <- df()$data %>%
          filter(Age == "All") %>%
          pivot_longer(Boys:Girls,
                       names_to = "Gender",
                       values_to = "Percentage")
      }
      
      if ("Rating" %in% colnames(plot_data)) {
        base_plot +
          geom_bar(
            data = plot_data,
            aes(Age, Percentage, fill = Rating),
            stat = "identity",
            position = "stack"
          ) +
          facet_wrap( ~ Gender)
      } else {
        base_plot +
          geom_bar(
            data = plot_data,
            aes(Age, Percentage, fill = Gender),
            stat = "identity",
            position = "dodge"
          )
      }
      
    })
    
    output$question <-
      renderText({
        req(input$select_var, df())
        df()$question
      })
    
  })
}

vars_by_age_app <- function() {
  ui <- tagList(tags$style(sass::sass(
    sass::sass_file("app/styles/shine_app.scss")
  )),
  vars_by_age_ui())
  
  server <- function(input, output, session) {
    vars_by_age_server()
  }
  shinyApp(ui, server)
}

vars_by_age_lp_box <- lp_main_box(
  title_box = "How are Scotland's young people doing?",
  description = "How did Scottish young people answer these questions about their health, excercise and how well they're doing?",
  button_name = "vars_by_age",
  image_name = "vars_by_age"
)


list(vars_by_age_ui, vars_by_age_server, vars_by_age_lp_box)