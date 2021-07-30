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
                            textOutput(ns("description")), style = "min-height: 20vh"),
                        fluidRow(plotOutput(ns("plot"), height = "40vh"))
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
      left_join(country_codes, by = c("country_region" = "code")) %>%
      mutate(
        sco = ifelse(country_region == "GB-SCT", paste("Scotland\n", value, "%"), NA),
        country = str_remove_all(name, "(United Kingdom |\\(|\\))") %>% str_replace("(?<=Belgium)", ":"),
        tooltip = paste0(country, ":\n", value, "%")
      ) %>%
      filter(age_grp == "15YO") %>%
      ggplot(aes(x = value, y = "box", text = tooltip)) +
      stat_summary(aes(group = "box"),
        fun.data = function(t) {
          tibble(
            middle = mean(t),
            ymin = min(t),
            ymax = max(t),
            lower = ymin,
            upper = ymax
          )
        },
        geom = "boxplot",
        width = 2,
        fill = "#DFBFC3"
      ) +
      # geom_text_repel(aes(label = sco), nudge_y = 0.55, box.padding = 2, size = pts(16), point.padding = 1,colour = secondary_colour) +
      scale_shape_manual(values = c(18, 18)) +
      theme(
        legend.position = "none",
        axis.title.y = element_blank(),
        # plot.margin = margin(0, 10, 0, 10),
        panel.grid.major.y = element_blank(),
        axis.text.y = element_blank()
      ) +  scale_x_continuous(
        comparison()$title,
        labels = percent_format(accuracy = 1, scale = 1),
        limits = c(0, 100)
      ) +
      stat_summary(
        aes(y = "label", group = sex),
        fun.data = function(t) {
          tibble(y = c(min(t), mean(t), max(t)),
                 label = c(
                   paste0("Lowest:\n", min(t), "%"),
                   paste0("Average:\n", round(mean(t)), "%"),
                   paste0("Highest:\n", max(t), "%")
                 ))
        },
        geom = "text_repel",
        size = pts(18),
        # vjust = 1,
        hjust = 0.5,
        # nudge_x = -10,
        # nudge_y = -10,
        # direction = "x",
        min.segment.length = 0.1,
        # point.padding = 10,
        # box.padding = 0.1,
        force_pull = 100,
        xlim = c(-Inf, Inf),
        ylim = c(-Inf, Inf),
        colour = "#696969",
        position = position_nudge_repel(y = 0.5)
      ) +
      geom_text_repel(
        aes(label = sco),
        position = position_nudge_repel(y = -1.5),
        box.padding = 0.5,
        size = pts(16),
        point.padding = 1,
        colour = secondary_colour,
        label.size = NA,
        fill = "#ffffffcc",
        label.r = 0
      ) +
      coord_cartesian(ylim = c(-1, 3),
                      expand = expansion(add = 0),
                      clip = "off")+
      geom_point(colour = "#696969", size = 3) +
      geom_point(aes(shape = sco), size = 6, colour = secondary_colour) +
      theme(
        panel.background = element_rect(fill = "#eeeeee", colour = "white"),
        panel.grid.major.x = element_line(colour = "white"),
        plot.margin = margin(1, 2, 1, 2, unit = "lines"),
        panel.spacing = unit(3, "lines")
      ) -> non_facet_plot
    
    print(input$win_width)
    
    if(input$win_width>600) {
      non_facet_plot + facet_wrap( ~ sex, scales = "free", nrow = 1)
    } else {
      non_facet_plot + facet_wrap( ~ sex, scales = "free", nrow = 2)
    }
    
    
      # Replaced by above
      # geom_point(aes(shape = sco), size = 3) +
      # geom_text_repel(aes(label = sco), nudge_y = 0.1, box.padding = 2, size = pts(16), point.padding = 1) +
      # scale_shape_manual(values = 18) +
      # theme(legend.position = "none",
      #       axis.title.y = element_blank(),
      #       # plot.margin = margin(0, 10, 0, 10),
      #       panel.grid.major.y = element_blank(),
      #       axis.text.y = element_blank()
      #       ) +
      # 
      # scale_x_continuous(comparison()$title, labels = percent_format(accuracy = 1, scale = 1), 
      #                    limits = c(0, 100)) +
      # stat_summary(
      #   aes(y = "label"),
      #   fun.data = function(t) {
      #     tibble(
      #       y = c(min(t), median(t), max(t)),
      #       label = c(paste0("Lowest:\n", min(t), "%"),
      #                 paste0("Average:\n", round(mean(t)), "%"),
      #                 paste0("Highest:\n", max(t), "%"))
      #     )
      #   },
      #   geom = "text",
      #   size = pts(16),
      #   vjust = 1,
      #   hjust = 0.5,
      #   # nudge_x = 15,
      #   nudge_y = 2,
      #   colour = "#696969"
      #   # direction = "x",
      #   # min.segment.length = 0.1
      # ) +
      # coord_cartesian(ylim = c(0.9, 1.5))
    
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
