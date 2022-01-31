vars_by_age_ui <- function(id = "vars_by_age") {
  ns <- NS("vars_by_age")
  fluidPage(style = "display: flex;",
            
            mainPanel(
              id = ns("main-panel"),
              class = "app-panel col-lg-8",
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
              ),
              data_sources
            ))
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
        width = "100%",
        # selected = "Report good or excellent health",
        selectize = FALSE,
      )
    })
    
    df <- reactive({
      vars_by_age[[input$select_var]]
    })
    
    
    output$plot <- renderPlot({
      req(input$select_var, df())
      
      base_plot <- ggplot() +
        theme(
          panel.grid.major.x = element_blank(),
          axis.title.y = element_text(angle = 0, vjust = 0.5)
        ) +
        scale_y_continuous(
          name = paste0(
            paste0(rep(" ", 40), collapse = ""),
            "\n",
            str_wrap(df()$axis_label, 20)
          ),
          labels = percent_format(scale = 1, accuracy = 1),
          limits = c(0, 100),
          breaks = seq(0, 100, 10),
          expand = expansion()
        ) +
        scale_fill_manual(
          values = c(
            "Girls" = global_girls_colour,
            "Boys" = global_boys_colour,
            "Excellent" = global_excel_colour,
            "Good" = global_good_colour
          ),
          limits = force
        ) +
        scale_alpha_manual(values = c("Excellent" = 1, "Good" = 0.5))
      
      plot_data <- df()$data
      
      if (input$agegrp) {
        plot_data <- plot_data %>%
          filter(!str_detect(Age, "All.?")) %>%
          mutate(Age = str_remove_all(Age, "\\W$")) %>%
          pivot_longer(Boys:Girls,
                       names_to = "Gender",
                       values_to = "Percentage")
        
        x_map <- "Age"
        x_map_alt <- "Gender"
      } else {
        plot_data <- plot_data %>%
          filter(str_detect(Age, "All.?")) %>%
          mutate(Age = str_remove_all(Age, "\\W$")) %>%
          pivot_longer(Boys:Girls,
                       names_to = "Gender",
                       values_to = "Percentage")
        
        x_map <- "Gender"
        x_map_alt <- "Gender"
      }
      
      
      if ("Rating" %in% colnames(plot_data)) {
        plot_out <- base_plot +
          geom_bar(
            data = plot_data,
            aes(Gender, Percentage, fill = Gender, alpha = Rating),
            stat = "identity",
            position = "stack",
            width = 1
          ) +
          facet_wrap( ~ Age, strip.position = "bottom") +
          scale_x_discrete(x_map, expand = expansion(mult = 0.9)) +
          theme(panel.spacing = grid::unit(-1, "lines"),
                axis.text.x =  element_blank())
      } else {
        # browser()
        plot_out <- base_plot +
          geom_bar(
            data = plot_data,
            aes(!!sym(x_map), Percentage, fill = Gender),
            stat = "identity",
            position = "dodge"
          )
      }
      plot_out
    }) %>% bindCache(input$select_var, input$agegrp)
    
    
    
    
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
  description = "How did Scottish young people answer these questions about their health, exercise and how well they're doing?",
  button_name = "vars_by_age",
  image_name = "vars_by_age"
)


list(vars_by_age_ui, vars_by_age_server, vars_by_age_lp_box)