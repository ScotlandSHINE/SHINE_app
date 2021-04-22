# Setup parts -------------------------------------------------------------
library(shiny)
library(tidyverse)
library(sass)
library(bslib)

options(sass.cache = FALSE)

primary_colour <-  "#2e3192"
secondary_colour <- "#016bb2"
main_colour <- "#333333"

css <- sass(sass_file("app/styles/shine_app.scss"))

theme_set(theme_minimal() +
            theme(text = element_text(colour = main_colour),
                  line = element_line(colour = main_colour),
                  axis.title = element_text(colour = secondary_colour,
                                            size = 12)))
update_geom_defaults("bar",   list(fill = primary_colour))

# Social media use app ----------------------------------------------------

source("app/components/soc_med_use.R")

soc_med_data <- function() {
  load("app/data/prob_soc_med.RData", envir = parent.frame(2))
}

soc_med_data()


soc_med_app()
