library(shinytest2)

test_that("{shinytest2} recording: vars-by-age", {
  app <- AppDriver$new(name = "vars-by-age", height = 754, 
      width = 1235, load_timeout = 5000)
  app$click("vars_by_age")
  app$set_inputs(`vars_by_age-select_var` = "Been bullied at least 2-3 times a month in the past couple of months")
  app$expect_values()
})


test_that("{shinytest2} recording: influences", {
  app <- AppDriver$new(name = "influences", height = 754, width = 1235)
  app$click("influences")
  app$set_inputs(`influences-exposure` = "Pressured by schoolwork")
  app$set_inputs(`influences-outcome` = "Life satisfaction")
  app$expect_values()
})


test_that("{shinytest2} recording: time_changes", {
  app <- AppDriver$new(name = "time_changes", seed = 222, height = 754, width = 1235)
  app$click("time_changes")
  app$set_inputs(`time_changes-select_var` = "Playing computer games for 2 or more hours a day on weekdays 2006-2018")
  app$expect_values()
})
