compare_countries_ui <- function(id = "compare_countries") {
  ns <- NS("compare_countries")
  
  fluidPage(style = "display: flex;",
            
            mainPanel(id = ns("main-panel"), class = "app-panel col-lg-8",
                      fluidPage(
                        class = "cont-panel",
                        titlePanel("How does Scotland compare with other countries?"),
                        fluidRow( 
                          style = "display: flex; align-items: flex-end",
                          column(12,
                                 uiOutput(ns("var_sel"))),
                        ),
                        fluidRow(class = "question",
                            textOutput(ns("description")), style = "min-height: 15vh"),
                        fluidRow(style = "min-height: 60vh", plotlyOutput(ns("plot") # , height = "45vh"  # , hover = ns("plot_hover")
                                            )),
                      ), data_sources
                      ))
  
} 

compare_countries_server <- function(id = "compare_countries") {
  moduleServer(id, function(input, output, session) {
    
    output$var_sel <- renderUI({
      req(compare_countries)
      ns <- session$ns
      selectInput(
        ns("select_var"),
        "Select a health topic to compare across countries:",
        choices = names(compare_countries),
        width = "100%",
        selectize = FALSE
      )
    })
    
    comparison <- reactive({compare_countries[[input$select_var]]})
    
    output$description <- renderText({
      req(input$select_var, comparison())
      comparison()$description
    })
    
    output$plot <- renderPlotly({
      req(input$select_var, comparison())
      
      
      scot_lab_dat <- comparison()$data %>%
        filter(age_grp == "15YO", country_region == "GB-SCT") %>%
        mutate(sco = factor(1),
               sco_lab = paste("Scotland\n", value, "%"), 
               value = case_when(value<10 ~ 10, value > 90 ~ 90, TRUE ~ value))
      
      # eng_lab_dat <- comparison()$data %>%
      #   filter(age_grp == "15YO", country_region == "GB-ENG") %>%
      #   mutate(sco = factor(2),
      #          eng_lab = paste("England\n", value, "%"))
      # 
      comparison()$data %>%
        left_join(country_codes, by = c("country_region" = "code")) %>%
        mutate(
          # sco = factor(ifelse(country_region == "GB-SCT", 1, ifelse(country_region == "GB-ENG", 2, 0))),
          sco = factor(case_when(country_region == "GB-SCT" ~ 1,
                           country_region == "GB-ENG" ~ 2,
                           country_region == "GB-WLS" ~ 3,
                           country_region == "IRL" ~ 4,
                           TRUE ~ 0)),
          eng = country_region == "GB-ENG",
          eng_lab = ifelse(eng, paste("England\n", value, "%"), NA),
          country = str_remove_all(name, "(United Kingdom |\\(|\\))") %>% str_replace("(?<=Belgium)", ":"),
          tooltip = paste0(country, ":\n", value, "%")
        ) %>%
        filter(age_grp == "15YO") %>%
        ggplot(aes(y = value, x = 0, text = tooltip)) +
        stat_summary(
          aes(
            xmin = -1,
            xmax = 1,
            group = "box",
            text = paste0("Range:\n", after_stat(ymin), "% to ", after_stat(ymax), "%")
          ),
          geom = "rect",
          fun.data = function(p) {
            tibble(ymin = min(p),
                   ymax = max(p),
                   y = 1)
          },
          fill = "#111177",
          alpha = 0.2
        ) +
        coord_flip(ylim = c(0, 100), xlim = c(-1.2, 2), clip = "off") +
        stat_summary(
          aes(
            xmin = -1,
            xmax = 1,
            group = "box",
            text = paste0("Average: ", round(after_stat(y),0), "%")
          ),
          geom = "rect",
          fun.data = function(p) {
            tibble(y = mean(p),
                   ymin = y - 0.5,
                   ymax = y + 0.5,
            )
          },
          fill = "#111177",
          alpha = 0.3
        ) +
        geom_point(aes(
          shape = sco,
          colour = sco,
          size = sco
        )) +
        scale_shape_manual(values = c(18, 18, 18, 18, 18)) +
        scale_size_manual(values = c(1, 3, 1, 1, 1)) +
        scale_colour_manual(values = c("#696969", secondary_colour, "red", "#257027", "#0DCB12")) +
        theme(
          legend.position = "none",
          axis.title.y = element_blank(),
          panel.grid.major.y = element_blank(),
          axis.text.y = element_blank(),
          panel.background = element_rect(fill = "#eeeeee", colour = "white"),
          panel.grid.major.x = element_line(colour = "white"),
          plot.margin = margin(1, 2, 2, 2, unit = "lines"),
          panel.spacing = unit(3, "lines"),
          axis.title.x = element_text(size = 16),
          axis.text.x = element_text(size = 10)
        ) +
        scale_y_continuous(
          # paste0("&nbsp;\n", str_wrap(comparison()$title, 70)),
          str_wrap(comparison()$title, 70),
          labels = percent_format(accuracy = 1, scale = 1),
          limits = c(0, 100),
          breaks = seq(0, 100, 20),
          expand = expansion(0)
        ) +
        stat_summary(
          aes(group = sex, x = 1.5, text = ""),
          fun.data = function(t) {
            y_pos = if (mean(t) < 25)
              25
            else if (mean(t) > 75)
              75
            else
              mean(t)
            tibble(
              y = y_pos,
              ymax = y,
              ymin = y,
              label = paste(
                paste0("Lowest: ", min(t), "%"),
                paste0("Average: ", round(mean(t)), "%"),
                paste0("Highest: ", max(t), "%"),
                sep = "\n"
              )
            )
          },
          geom = "text",
          size = pts(12),
          vjust = 0,
          hjust = 0.5,
          colour = "#696969",
        ) +
        # geom_text(
        #   data = eng_lab_dat,
        #   aes(
        #     label = eng_lab,
        #     x = 0.5,
        #     colour = sco,
        #     text = eng_lab
        #   ), fontface = "bold") +
        geom_text(
          data = scot_lab_dat,
          aes(
            label = sco_lab,
            x = -0.5,
            colour = sco,
            text = sco_lab
          ),
          fontface = "bold"
        ) -> non_facet_plot
      
    if(max(700, input$win_width) >600) {
      gg_part <- non_facet_plot + facet_wrap( ~ sex, scales = "free", nrow = 1)
    } else {
      gg_part <- non_facet_plot + facet_wrap( ~ sex, scales = "free", nrow = 2)
    }

    # gg_part <-  non_facet_plot + facet_wrap( ~ sex, scales = "free", nrow = 1)
      ggplotly(gg_part, height = 400, tooltip = "text") %>%
        config(displayModeBar = FALSE) %>%
        layout(
          xaxis = list(fixedrange = TRUE),
          xaxis2 = list(fixedrange = TRUE),
          yaxis = list(fixedrange = TRUE),
          yaxis2 = list(fixedrange = TRUE),
          margin = list(b = 120)
        )
      
    }) %>% bindCache(input$winwidth, input$select_var)
    
    
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
