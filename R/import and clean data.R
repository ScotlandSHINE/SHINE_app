library(readr)
library(tidyverse)
library(janitor)
library(readxl)

country_codes <- read_excel("import/HBSC_30_EN.xlsx",
                            sheet = "Countries") %>%
  select(code = Code, name = `Short name`)

save(country_codes, file = "app/data/country_codes.RData")

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


dfs <- readxl::excel_sheets("import/app1_data.xlsx")[-1] %>%
  map(function(sheet) {
    title <-
      read_excel(
        "import/app1_data.xlsx",
        sheet = sheet,
        n_max = 1,
        col_names = FALSE
      )[[1]]
    question <-
      read_excel(
        "import/app1_data.xlsx",
        sheet = sheet,
        skip = 1,
        n_max = 1,
        col_names = FALSE
      )[[1]]
    axis_label <-
      read_excel(
        "import/app1_data.xlsx",
        sheet = sheet,
        skip = 1,
        n_max = 1,
        col_names = FALSE
      )[[2]]
    df <-
      read_excel("import/app1_data.xlsx", sheet = sheet, skip = 2)
    list(
      title = title,
      question = question,
      axis_label = axis_label,
      data = df
    )
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
    lifesat,
    smok30d_2,
    drunk30d
  )

labs_cats <- tribble(	~variable, ~lab, ~cat, ~question,	
  "sex",  "Gender", "group",  "",
  "AGECAT", "Age category", "group",  "",
  "breakfastwd",  "Breakfast on schooldays", "exposure",  "Do you have breakfast every day on schooldays?",
  "fruits",	"Eating fruit", "exposure",	"How many times a week do you usually eat fruits?",
  "sweets",	"Eating sweets", "exposure",	"How many times a week do you usually eat sweets or chocolate?",
  "family_meal_eve",	"Family meals in the evening", "exposure", "How often do you have an evening meal together with your mother or father?",
  "timeexe",	"Time exercising", "exposure",	"Outside of school hours, how often do you usually exercise?",
  "tvwd",	"Time watching TV", "exposure",	"How many hours a day on weekdays do you spend watching TV?",
  "playgamewd",	"Playing computer games", "exposure",	"How many hours a day on weekdays do you spend playing computer games?",
  "bulliedothers",	"Bullying others", "exposure",	"Have you taken part in bullying others in the last couple of months?",
  "beenbullied",	"Being bullied", "exposure",	"Have you been bullied at school in the past couple of months?",
  "cbullmess",	"",	"",	"",	
  "cbullpict",	"",	"",	"",	
  "talkfather",	"",	"",	"",	
  "talkstepfa",	"",	"",	"",	
  "talkmother",	"",	"",	"",
  "talkstepmo",	"",	"",	"",
  "talk_listen",	"",	"",	"",
  "famhelp",	"Family helpful", "exposure",	"\"My family really tries to help me\"",
  "famsup",	"",	"",	"",
  "famdec",	"",	"",	"",
  "famtalk",	"",	"",	"",
  "friends_ph_int", "Talk to friends - phone and internet", "exposure",	"How often do you talk to your friends on the phone or internet?",
  "acachieve",	"",	"",	"",
  "studtogether",	"",	"",	"",
  "studaccept",	"",	"",	"",
  "teacheraccept",	"",	"",	"",
  "teachercare",	"",	"",	"",
  "teachertust",	"",	"",	"",
  "fasbedroom",	"",	"",	"",
  "welloff",	"",	"",	"",
  "likeschool",	"",	"",	"",
  "thinkbody",	"Thinking about body",	"",	"Do you think your body is...?",
  "feellow",	"Feeling low",  "outcome",	"% who feel low more than once a week",
  "nervous",	"Feeling nervous",  "",	"In the last 6 months, have you often felt nervous?",
  "sleepdificulty",	"Difficulty sleeping",  "",	"In the last 6 months, have you often had difficulies getting to sleep?",
  "health",	"Health",  "outcome",	"% who rate their health as good or excellent",
  "lifesat",	"Life satisfaction",  "outcome",	"% who report 'high' life satisfaction",
  "schoolpressure", "Pressured by schoolwork", "exposure", "How pressured do you feel by the schoolwork you have to do?",
  "smok30d_2", "Smoked in the past 30 days", "exposure", "Have you smoked a cigarette in the past 30 days?",
  "drunk30d", "Been drunk in the past 30 days", "exposure", "Have you been drunk in the past 30 days?"
) %>% filter(cat != "")


influences_data <-
  hbsc_data %>%
  transmute(
    sex = factor(sex, labels = c("1" = "Boy", "2" = "Girl")),
    AGECAT = factor(AGECAT, labels = c(
      "11 year-olds", "13 year-olds", "15 year-olds"
    )),
    breakfastwd = factor(breakfastwd == 6, labels = c("No", "Yes")),
    fruits = factor(fruits == 6, labels = c("Less often", "Every day")),
    sweets = factor(sweets == 6, labels = c("Less often", "Every day")),
    # family_meal_eve = factor(family_meal_eve == 6, labels = c("Less often", "Every day")),
    # timeexe = factor(timeexe < 4, labels = c("2-3 times a week or more", "Less often")),
    # tvwd = factor(tvwd > 4, labels = c("Less than 3 hours", "3 or more")),
    # playgamewd = factor(playgamewd > 3, labels = c("Less than 2 hours", "2 or more")),
    bulliedothers = factor(bulliedothers > 2, labels = c("No", "Yes")),
    beenbullied = factor(beenbullied > 2, labels = c("No", "Yes")),
    famhelp = factor(famhelp > 5, labels = c("No", "Yes")),
    # friends_ph_int = factor(friends_ph_int == 4, labels = c("Less often", "Every day")),
    # thinkbody = factor(thinkbody < 3, labels = c("Less often", "More than once a week")),
    feellow = factor(feellow < 3, labels = c("Less often", "In the last 6 months, I have felt low more than once a week")),
    nervous = factor(nervous < 3, labels = c("Less often", "In the last 6 months, I have felt nervous more than once a week")),
    sleepdificulty = factor(sleepdificulty < 3, labels = c("Less often", "In the last 6 months, I have had difficulties getting to sleep more than once a week")),
    health = factor(health < 3, labels = c("Fair or Poor", "I would rate my health 'Good' or 'Excellent'")),
    lifesat = factor(lifesat > 7, labels = c("Fair or Poor", "I have 'high' life satisfaction")),
    schoolpressure = factor(schoolpressure > 2, labels = c("A little or not at all", "Some or a lot")),
    smok30d_2 = factor(smok30d_2 > 1, labels = c("No", "Yes")),
    drunk30d = factor(drunk30d > 1, labels = c("No", "Yes"))
  )

save(influences_data, labs_cats, file = "app/data/influences.RData")


# app 3 - time_changes data -------------------------------------------------------

time_changes_import <- excel_sheets("import/app3_data.xlsx") %>%
  map(function(sheet) {
    title <-
      read_excel(
        "import/app3_data.xlsx",
        sheet = sheet,
        n_max = 1,
        col_names = FALSE
      )[[1]]
    question <-
      read_excel(
        "import/app3_data.xlsx",
        sheet = sheet,
        skip = 1,
        n_max = 1,
        col_names = FALSE
      )[[1]]
    axis_label <-
      read_excel(
        "import/app3_data.xlsx",
        sheet = sheet,
        skip = 1,
        n_max = 1,
        col_names = FALSE
      )[[2]]
    df <-
      read_excel("import/app3_data.xlsx", sheet = sheet, skip = 2)
    list(title = title, question = question, axis_label = axis_label, data = df)
  })

time_changes <-
  set_names(time_changes_import, map(time_changes_import, ~ .x$title)) %>%
  # map(time_changes_import, ~ make_clean_names(.x$title))) %>%
  map( ~ {
    .x$data <- .x$data %>%
      rename(Year = ...1) %>%
      mutate(sign = ifelse(str_detect(Year, "†"), TRUE, FALSE),
             Year = as.factor(str_extract(Year, "^\\d{4}")))
    .x
  })

save(time_changes, file = "app/data/time_changes.RData")


# app 4 -  data for country comparisons -------------------------------------

compare_countries <- dir("import") %>%
  str_subset("^HBSC.*\\.xlsx") %>%
  map( ~ {
    variable_import <-
      read_excel(file.path("import", .x), sheet = "Data (table)")
    variable_desc <-
      read_excel(file.path("import", .x), sheet = "Measure notes")$Note[1]
    variable_indicator <-
      read_excel(file.path("import", .x), sheet = "Classifications")$`Measure name`
    
    variable_data <- variable_import %>%
      clean_names() %>%
      select(age_grp, sex, country_region, year, value) %>%
      filter(year == max(year), country_region %in% country_codes$code) %>%
      mutate(sex = case_when(
        sex == "ALL" ~ "All",
        # No 'All' totals for separate countries
        sex == "MALE" ~ "Boys",
        sex == "FEMALE" ~ "Girls"
      ))
    list(
      title = str_remove(variable_indicator, "(?<=ther)s$"),
      description = variable_desc %>% str_remove(" ?No data.*$") %>% str_remove("Note.*"),
      data = variable_data
    )
  })

order <- c(
  "Proportion of young people who eat breakfast every weekday",
  "Proportion of young people who have drunk alcohol in the last 30 days",
  "Proportion of young people who have been cyber bullied one time or more in the last couple of months",
  "Proportion of young people who have cyber bullied others one time or more in the last couple of months",
  "Proportion of young people who eat fruit at least once a day",
  "Proportion of young people who have been bullied at school at least twice in the past couple of months",
  "Proportion of young people who have bullied others at school at least twice in the last couple of months",
  "Proportion of young people who find it easy to talk to their mother",
  "Proportion of young people who find it easy to talk to their father",
  "Proportion of young people who like school a lot",
  "Proportion of young people who feel pressured by schoolwork",
  "Proportion of young people who eat vegetables at least every day or more than once a day",
  "Proportion of young people who eat sweets every day",
  "Proportion of young people who experience difficulties getting to sleep more than once a week",
  "Proportion of young people who eat breakfast together with their family every day",
  "Proportion of young people who have smoked 1-2 days or more in their lifetime",
  "Proportion of young people who eat a meal with family every day",
  "Proportion of young people who brush their teeth more than once a day"
)

compare_countries <- compare_countries %>%
  set_names(., map(., ~ .x$title))

compare_countries <- compare_countries[order]

save(compare_countries, file = "app/data/compare_countries.RData")




dir("import") %>%
  str_subset("^HBSC.*\\.xlsx") %>% 
  tibble(file = .) %>% 
  mutate(desc =  map_chr(file, ~ read_excel(file.path("import", .x), sheet = "Measure notes")$Note[1])) %>% 
  mutate(len = str_length(desc)) %>% 
  arrange(desc(len))

         

dir("import") %>%
  str_subset("^HBSC.*\\.xlsx") %>% 
  tibble(file = .) %>% 
  mutate(desc =  map_chr(file, ~read_excel(file.path("import", .x), sheet = "Classifications")$`Measure name`)) %>% 
  arrange(desc)

         