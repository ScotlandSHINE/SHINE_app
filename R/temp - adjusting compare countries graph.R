compare_countries$`Proportion of young people who think they are too fat`$data %>%
  left_join(country_codes, by = c("country_region" = "code")) %>%
  mutate(
    sco = ifelse(country_region == "GB-SCT", paste("Scotland\n", value, "%"), NA),
    country = str_remove_all(name, "(United Kingdom |\\(|\\))") %>% str_replace("(?<=Belgium)", ":"),
    tooltip = paste0(country, ":\n", value, "%")
  ) %>%
  filter(age_grp == "15YO") %>%
  ggplot(aes(x = value, y = "box", text = tooltip)) +
  # geom_rect(aes(ymax = 0.75, ymin = 1.25, xmin = min(value), xmax = max(value))) +
  # stat_summary(
  #   fun.data = function(t) {
  #     tibble(
  #       # middle = mean(t),
  #       ymin = min(t),
  #       ymax = max(t),
  #       xmin = 0.75,
  #       xmax = 1.25
  #       # lower = ymin,
  #       # upper = ymax
#     )
#   },
#   geom = "rect",
#   fill = "#DFBFC3"
#   ) +
stat_summary(
  aes(group = "box"),
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
  scale_shape_manual(values = c(18, 18)) +
  theme(
    legend.position = "none",
    axis.title.y = element_blank(),
    # plot.margin = margin(0, 10, 0, 10),
    panel.grid.major.y = element_blank(),
    axis.text.y = element_blank()
  ) +  scale_x_continuous(
    compare_countries$`Proportion of young people who eat sweets at least every day or more than once a day`$title,
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
    size = pts(16),
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
    position = position_nudge_repel(y = 1.5)
  ) +
  geom_label_repel(
    aes(label = sco),
    nudge_y = 1.5,
    box.padding = 0.5,
    size = pts(16),
    point.padding = 1,
    colour = secondary_colour,
    label.size = NA,
    fill = "#ffffffcc",
    label.r = 0
  ) +
  coord_cartesian(ylim = c(-0.4, 4),
                  expand = expansion(add = 0),
                  clip = "off") +
  geom_point(colour = "#696969") +
  geom_point(aes(shape = sco), size = 3, colour = secondary_colour) +
  theme(
    panel.background = element_rect(fill = "#eeeeee", colour = "white"),
    panel.grid.major.x = element_line(colour = "white"),
    plot.margin = margin(1, 2, 1, 2, unit = "lines"),
    panel.spacing = unit(3, "lines")
  ) +
  facet_wrap( ~ sex, scales = "free")#-> plotly_version

ggplotly(plotly_version, tooltip = "text")
