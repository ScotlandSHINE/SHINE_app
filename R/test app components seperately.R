# Setup parts -------------------------------------------------------------
library(shiny)
library(tidyverse)
library(sass)
library(bslib)

options(sass.cache = FALSE)

load("app/data/prob_soc_med.RData")
theme_set(theme_minimal())

css <- sass(sass_file("app/styles/shine_app.scss"))

test_shiny_app <- function(component) {
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

# Social media use app ----------------------------------------------------

source("app/components/soc_med_use.R")
test_shiny_app("soc_med")
