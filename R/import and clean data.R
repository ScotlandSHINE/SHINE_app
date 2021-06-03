library(readr)
library(tidyverse)
library(janitor)


# comparing variables -----------------------------------------------------

prob_soc_med_raw <- read_csv("import/HBSC_151_EN.csv",
                             skip = 34)


prob_soc_med <- prob_soc_med_raw %>%
  filter(!is.na(COUNTRY)) %>%
  clean_names() %>%
  select(country, age_grp_2, sex, year, value)

# save(prob_soc_med, file = "app/data/prob_soc_med.RData")


breakfast_fam_raw <- read_csv("import/HBSC_63_EN.csv", skip = 29)

breakfast_fam <- breakfast_fam_raw %>%
  filter(!is.na(COUNTRY)) %>%
  clean_names() %>%
  select(country, age_grp_2, sex, year, value)

soc_med_time_raw <- read_csv("import/HBSC_68_EN.csv", skip = 29)

soc_med_time <- soc_med_time_raw %>% 
  filter(!is.na(COUNTRY)) %>%
  clean_names() %>%
  select(country, age_grp_2, sex, year, value)

save(prob_soc_med, soc_med_time, breakfast_fam, file = "app/data/compare_var.RData")


# app 1 - health variables across Scotland --------------------------------

library(readxl)

# sheet <- 2
# dfs <- list()
# rows_left <- TRUE
# 
# while(rows_left) {
#   tryCatch(
#     {
#       title <- read_excel("import/app1_data.xlsx", sheet = sheet, n_max = 1, col_names = FALSE)[[1]]
#       df <- read_excel("import/app1_data.xlsx", sheet = sheet, skip = 1)
#       print(title)
#       print(df)
#       dfs[[title]] <- df
#     },
#     error = function(e) rows_left <<- FALSE
#     )
#       sheet <- sheet + 1
# }

dfs <- readxl::excel_sheets("import/app1_data.xlsx")[-1] %>% 
  map(function(sheet){
    title <- read_excel("import/app1_data.xlsx", sheet = sheet, n_max = 1, col_names = FALSE)[[1]]
    question <- read_excel("import/app1_data.xlsx", sheet = sheet, skip = 1, n_max = 1, col_names = FALSE)[[1]]
    axis_label <- read_excel("import/app1_data.xlsx", sheet = sheet, skip = 1, n_max = 1, col_names = FALSE)[[2]]
    df <- read_excel("import/app1_data.xlsx", sheet = sheet, skip = 2)
    list(title = title, question = question, axis_label = axis_label, data = df)
  })




vars_by_age <- set_names(dfs, map(dfs, ~ .x$title))

save(vars_by_age, file = "app/data/vars_by_age.RData")
