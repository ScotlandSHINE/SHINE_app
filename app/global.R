library(shiny)
library(tidyverse)
library(sass)
library(bslib)
library(zeallot)
library(scales)
# library(shinyWidgets)
# library(crosstalk)
library(plotly)
library(ggrepel)
source("R/functions.R")

# Setting display options for whole app -----------------------------------


options(sass.cache = FALSE)

tryCatch(sass(sass_file("styles/shine_app.scss"),
         output = "www/shine_app.css"),
         error = function(e) cat("'www/shine_app.css' not writable"))


# Setting standard display of text and graphs

primary_colour <-  "#2e3192"
secondary_colour <- "#016bb2"
main_colour <- "#333333"
global_girls_colour <- "#FFB948"
global_boys_colour <- "#BE4D00"
# global_girls_colour <- "#edae49"
# global_boys_colour <- "#66a182"
global_good_colour <- "#8d96a3"
global_excel_colour <- "#00798c" 

# Retired colours
# global_girls_colour <- "#ff44cc"
# global_boys_colour <- "#2266ee"
# global_good_colour <- "#2DAAE1"
# global_excel_colour <- "#e30088" 


theme_set(theme_minimal() +
            theme(text = element_text(colour = main_colour, size = 18),
                  line = element_line(colour = main_colour),
                  axis.title = element_text(colour = secondary_colour,
                                            size = 18),
                  axis.title.y = element_text(margin = margin(r = 15, unit = "pt")),
                  axis.title.x = element_text(margin = margin(t = 15, unit = "pt")),
          legend.key.size = unit(40, "pt"),
          legend.text = element_text(size = 22),
          legend.key = element_blank()))

# update_geom_defaults("bar",   list(fill = primary_colour))

load("data/country_codes.RData")

# Loading components and setting data functions ---------------------------

# Social media use

# Functions to load data so that they only load when needed on page
soc_med_data <- function() {
  load("data/prob_soc_med.RData", envir = .GlobalEnv)
  message("Loaded data for soc med app component\n")
}

# unpacking the three expected elements in the list call in the app creation script
c(soc_med_ui, soc_med_server, soc_med_lpBox) %<-% load_component("soc_med_use")

load_vars_by_age_data <- function() {
  load("data/vars_by_age.RData", envir = .GlobalEnv)
  message("Loaded data for vars by age component")
}


c(vars_by_age_ui, vars_by_age_server, vars_by_age_lp_box) %<-% load_component("vars_by_age")

# influences app

load_influences_data <- function() {
  load("data/influences.RData", envir = .GlobalEnv)
  message("Loaded data for influences component")
}

c(influences_ui, influences_server, influences_lp_box) %<-% load_component("influences")

# time changes app

time_changes_data <- function() {
  load("data/time_changes.RData", envir = .GlobalEnv)
  message("Loaded data for changes over time component")
}

c(time_changes_ui, time_changes_server, time_changes_lp_box) %<-% load_component("time_changes")

# compare countries

compare_countries_data <- function() {
  load("data/compare_countries.RData", envir = .GlobalEnv)
  message("Loaded data for comparing with other countries component")
}

c(compare_countries_ui, compare_countries_server, compare_countries_lp_box) %<-% load_component("compare_countries")

# chat bot

c(chat_bot_ui, chat_bot_server) %<-% load_component("chat_bot")

# Try loading data in global.R
load_vars_by_age_data()
load_influences_data()
time_changes_data()
compare_countries_data()