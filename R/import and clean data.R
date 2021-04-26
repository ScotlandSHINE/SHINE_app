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
