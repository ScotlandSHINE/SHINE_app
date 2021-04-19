library(shiny)
library(tidyverse)
library(bslib)
library(sass)

options(sass.cache = FALSE)

load("data/prob_soc_med.RData")
theme_set(theme_minimal())

try(sass(sass_file("styles/shine_app.scss"),
         output = "www/shine_app.css"))

source("components/soc_med_use.R")

#Creating big boxes for main tabs in the landing page (see ui for formatting css)
lp_main_box <-
  function(title_box,
           image_name,
           button_name,
           description) {
    div(
      class = "landing-page-box",
      div(title_box, class = "landing-page-box-title"),
      div(description, class = "landing-page-box-description"),
      div(
        class = "landing-page-icon",
        style = paste0(
          "background-image: url(images/",
          image_name,
          ".png);
          background-size: auto 80%; background-position: center; background-repeat: no-repeat; "
        )
      ),
      actionButton(button_name, NULL, class = "landing-page-button")
    )
  }
