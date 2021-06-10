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


# app 2 - influences on health and wellbeing ------------------------------

hbsc2014 <- readRDS("import/HBSC2014.rds")


hbsc_data <- hbsc2014 %>%
  filter(COUNTRYno == 826002) %>%
  select(
    sex,
    AGECAT,
    breakfastwd,
    fruits,
    sweets,
    family_meal_eve = m12,
    timeexe,
    tvwd,
    playgamewd,
    bulliedothers,
    beenbullied,
    cbullmess,
    cbullpict,
    talkfather,
    talkstepfa,
    talkmother,
    talkstepmo,
    talk_listen = m79,
    famhelp,
    famsup,
    famdec,
    famtalk,
    friends_ph_int = m90,
    acachieve,
    studtogether,
    studaccept,
    teacheraccept,
    teachercare,
    teachertust,
    fasbedroom,
    welloff,
    likeschool,
    schoolpressure,
    thinkbody,
    feellow,
    nervous,
    sleepdificulty,
    health,
    lifesat
  )

labs_cats <- tribble(
  ~variable, ~lab, ~cat, ~question,
  "sex", "Gender", "group", "",
  "AGECAT", "Age category", "group", "",
  "breakfastwd", "Breakfast on weekdays", "exposure", "Do you have breakfast every weekday?",
  "fruits", "Eating fruit", "exposure", "How many times a week do you usually eat fruits?",
  "sweets", "Eating sweets", "exposure", "How many times a week do you usually eat sweets or chocolate?",
  "family_meal_eve", "Family meals in the evening", "exposure", "How often do you have an evening meal together with your mother or father?",
  "timeexe", "Time exercising", "exposure", "Outside of school hours, how often do you usually exercise?",
  "tvwd", "Time watching TV", "exposure", "How many hours a day on weekdays do you spend watching TV?",
  "playgamewd", "Playing computer games", "exposure", "How many hours a day on weekdays do you spend playing computer games?",
  "bulliedothers", "Bullying others", "exposure", "Have you taken part in bullying others in the last couple of months?",
  "beenbullied", "Being bullied", "exposure", "Have you been bullied in the last couple of months?",
  "cbullmess", "", "", "",
  "cbullpict", "", "", "",
  "talkfather", "", "", "",
  "talkstepfa", "", "", "",
  "talkmother", "", "", "",
  "talkstepmo", "", "", "",
  "talk_listen", "", "", "",
  "famhelp", "Family helpful", "exposure", "\"My family really tries to help me\"",
  "famsup", "", "", "",
  "famdec", "", "", "",
  "famtalk", "", "", "",
  "friends_ph_int", "Talk to friends - phone and internet", "exposure", "How often do you talk to your friends on the phone or internet?",
  "acachieve", "", "", "",
  "studtogether", "", "", "",
  "studaccept", "", "", "",
  "teacheraccept", "", "", "",
  "teachercare", "", "", "",
  "teachertust", "", "", "",
  "fasbedroom", "", "", "",
  "welloff", "", "", "",
  "likeschool", "", "", "",
  "schoolpressure", "", "", "",
  "thinkbody", "Thinking about body", "", "Do you think your body is...?",
  "feellow", "Feeling low", "outcome", "In the last 6 months, have you often felt low?",
  "nervous", "Feeling nervous", "outcome", "In the last 6 months, have you often felt nervous?",
  "sleepdificulty", "Difficulty sleeping", "outcome", "In the last 6 months, have you often had difficulies getting to sleep?",
  "health", "Health", "outcome", "How would you rate your health?",
  "lifesat", "Life satisfaction", "outcome", "How happy do you feel with your life?"
) %>% filter(cat != "")


influences_data <- hbsc_data %>%
  transmute(
    sex = factor(sex, labels = c("1" = "Boy", "2" = "Girl")),
    AGECAT = factor(AGECAT, labels = c("11 year-olds", "13 year-olds", "15 year-olds")),
    breakfastwd = factor(breakfastwd == 6, labels = c("No", "Yes")),
    fruits = factor(fruits == 6, labels = c("Less often", "Every day")),
    sweets = factor(sweets == 6, labels = c("Less often", "Every day")),
    family_meal_eve = factor(family_meal_eve == 6, labels = c("Less often", "Every day")),
    timeexe = factor(timeexe < 4, labels = c("2-3 times a week or more", "Less often")),
    tvwd = factor(tvwd > 4, labels = c("Less than 3 hours", "3 or more")),
    playgamewd = factor(playgamewd > 3, labels = c("Less than 2 hours", "2 or more")),
    bulliedothers = factor(bulliedothers > 2, labels = c("No", "Yes")),
    beenbullied = factor(beenbullied > 2, labels = c("No", "Yes")),
    famhelp = factor(famhelp > 5, labels = c("No", "Yes")),
    friends_ph_int = factor(friends_ph_int == 4, labels = c("Less often", "Every day")),
    thinkbody = factor(thinkbody < 3, labels = c("Less often", "More than once a week")),
    feellow = factor(feellow < 3, labels = c("Less often", "More than once a week")),
    nervous = factor(nervous < 3, labels = c("Less often", "More than once a week")),
    sleepdificulty = factor(sleepdificulty < 3, labels = c("Less often", "More than once a week")),
    health = factor(health < 3, labels = c("Fair or Poor", "Good or Excellent")),
    lifesat = factor(lifesat > 7, labels = c("Fair or Poor", "Good or Excellent"))
  )

save(influences_data, labs_cats, file = "app/data/influences.RData")
