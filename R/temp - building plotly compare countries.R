ggplot2:::`+.gg`

`-.gg` <- function(e1, e2) {
  e2(e1)
}



  
    scot_lab_dat <- compare_countries$`Proportion of young people who find it easy to talk to their mothers`$data %>%
    filter(age_grp == "15YO", country_region == "GB-SCT") %>%
    mutate(sco = factor(1),
           sco_lab = paste("Scotland\n", value, "%"))
  
  eng_lab_dat <- compare_countries$`Proportion of young people who find it easy to talk to their mothers`$data %>%
    filter(age_grp == "15YO", country_region == "GB-ENG") %>%
    mutate(sco = factor(2),
           eng_lab = paste("England\n", value, "%"))
  
  compare_countries$`Proportion of young people who find it easy to talk to their mothers`$data %>%
    left_join(country_codes, by = c("country_region" = "code")) %>%
    mutate(
      sco = factor(ifelse(country_region == "GB-SCT", 1, ifelse(country_region == "GB-ENG", 2, 0))),
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
        text = "Range of %s"
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
    coord_flip(ylim = c(0, 100), xlim = c(-1.2, 2)) +
    stat_summary(
      aes(
        xmin = -1,
        xmax = 1,
        group = "box",
        text = "Average"
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
    scale_shape_manual(values = c(18, 18, 18)) +
    scale_size_manual(values = c(1, 3, 1)) +
    scale_colour_manual(values = c("#696969", secondary_colour, "red")) +
    theme(
      legend.position = "none",
      axis.title.y = element_blank(),
      panel.grid.major.y = element_blank(),
      axis.text.y = element_blank(),
      panel.background = element_rect(fill = "#eeeeee", colour = "white"),
      panel.grid.major.x = element_line(colour = "white"),
      plot.margin = margin(1, 2, 1, 2, unit = "lines"),
      panel.spacing = unit(3, "lines"),
      axis.title.x = element_text(size = 16)
    ) +
    scale_y_continuous(
      paste0("&nbsp;\n", str_wrap("Proportion of young people who find it easy to talk to their mothers", 100)),
      labels = percent_format(accuracy = 1, scale = 1),
      limits = c(0, 100),
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
    geom_text(
      data = eng_lab_dat,
      aes(
        label = eng_lab,
        x = 0.5,
        colour = sco,
        text = eng_lab
      ), fontface = "bold") +
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
  
  # if(isolate(input$win_width)>600) {
  #   gg_part <- non_facet_plot + facet_wrap( ~ sex, scales = "free", nrow = 1)
  # } else {
  #   gg_part <- non_facet_plot + facet_wrap( ~ sex, scales = "free", nrow = 2)
  # }
  
  gg_part <-  non_facet_plot + facet_wrap( ~ sex, scales = "free", nrow = 1)
  ggplotly(gg_part, tooltip = "text") %>%
    config(displayModeBar = FALSE)
  