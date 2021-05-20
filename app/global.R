library(shiny)
library(tidyverse)
library(sass)
library(bslib)
library(zeallot)
source("R/functions.R")

# Setting display options for whole app -----------------------------------


options(sass.cache = FALSE)

try(sass(sass_file("styles/shine_app.scss"),
         output = "www/shine_app.css"))


# Setting standard display of text and graphs

primary_colour <-  "#2e3192"
secondary_colour <- "#016bb2"
main_colour <- "#333333"

theme_set(theme_minimal() +
            theme(text = element_text(colour = main_colour),
                  line = element_line(colour = main_colour),
                  axis.title = element_text(colour = secondary_colour,
                                            size = 12)))
update_geom_defaults("bar",   list(fill = primary_colour))



# Loading components and setting data functions ---------------------------

# Social media use

# Functions to load data so that they only load when needed on page
soc_med_data <- function() {
  load("data/prob_soc_med.RData", envir = .GlobalEnv)
  message("Loaded data for soc med app component\n")
}

# unpacking the three expected elements in the list call in the app creation script
c(soc_med_ui, soc_med_server, soc_med_lpBox) %<-% load_component("soc_med_use")


c(vars_by_age_ui, vars_by_age_server, vars_by_age_lpBox) %<-% load_component("vars_by_age")