library(readr)
library(tidyverse)
library(janitor)

prob_soc_med_raw <- read_csv("import/HBSC_151_EN.csv", 
                         skip = 34)


prob_soc_med <- prob_soc_med_raw %>% 
  filter(!is.na(COUNTRY)) %>% 
  clean_names() %>% 
  select(country, age_grp_2, sex, year, value)

save(prob_soc_med, file = "app/data/prob_soc_med.RData")
