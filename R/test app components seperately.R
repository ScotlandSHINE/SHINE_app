# Setup parts -------------------------------------------------------------
library(shiny)
library(tidyverse)
library(sass)
library(bslib)
library(scales)
library(shinyWidgets)
library(plotly)
library(ggmosaic)

library(ggrepel)
options(sass.cache = FALSE)

primary_colour <-  "#2e3192"
secondary_colour <- "#016bb2"
main_colour <- "#333333"

css <- sass(sass_file("app/styles/shine_app.scss"))

theme_set(theme_minimal() +
            theme(text = element_text(colour = main_colour, size = 18),
                  line = element_line(colour = main_colour),
                  axis.title = element_text(colour = secondary_colour,
                                            size = 18)))
update_geom_defaults("bar",   list(fill = primary_colour))

load("app/data/country_codes.RData")

# Social media use app ----------------------------------------------------


# soc_med_data <- function() {
#   load("app/data/prob_soc_med.RData", envir = parent.frame(2))
# }
# 
# soc_med_data()
# 
# 
# source("app/components/soc_med_use.R")
# soc_med_app()



# vars by age app ---------------------------------------------------------


load_vars_by_age_data <- function() {
  load("app/data/vars_by_age.RData", parent.frame(2))
}

load_vars_by_age_data()

source("app/components/vars_by_age.R")
vars_by_age_app()



# influences on health and wellbeing --------------------------------------

load_influences_data <- function() {
  load("app/data/influences.RData", parent.frame(2))
}

load_influences_data()

source("app/components/influences.R")
influences_app()


# changes in health behaviours --------------------------------------------

time_changes_data <- function() {
  load("app/data/time_changes.RData", envir = .GlobalEnv)
}

time_changes_data()

source("app/components/time_changes.R")
time_changes_app()


# comparing with other countries ------------------------------------------

compare_countries_data <- function() {
  load("app/data/compare_countries.RData", envir = .GlobalEnv)
}

compare_countries_data()

source("app/components/compare_countries.R"); compare_countries_app()
