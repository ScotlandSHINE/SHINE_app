# Setup parts -------------------------------------------------------------
library(shiny)
library(tidyverse)
library(sass)
library(bslib)

options(sass.cache = FALSE)

load("app/data/prob_soc_med.RData")

primary_colour <-  "#2e3192"
secondary_colour <- "#016bb2"
main_colour <- "#333333"

theme_set(theme_minimal() +
            theme(text = element_text(colour = main_colour),
                  line = element_line(colour = main_colour),
                  axis.title = element_text(colour = secondary_colour,
                                            size = 12)))
update_geom_defaults("bar",   list(fill = primary_colour))

# Social media use app ----------------------------------------------------

source("app/components/soc_med_use.R")
load("app/data/prob_soc_med.RData")

test_soc_med <- function(component = "soc_med") {
  test_app <- function() {
    ui <- tagList(tags$style(css),
                  soc_med_ui(component))
    
    server <- function(input, output, session) {
      soc_med_serv(component)
    }
    
    shinyApp(ui, server)
  }
  test_app()
}

test_soc_med()
