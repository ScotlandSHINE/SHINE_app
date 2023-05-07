library(shinytest2)

test_that("{shinytest2} recording: vars-by-age", {
  app <- AppDriver$new(variant = platform_variant(), name = "vars-by-age", height = 754, 
      width = 1235, load_timeout = 5000)
  app$click("vars_by_age")
  app$set_inputs(`vars_by_age-select_var` = "Been bullied at least 2-3 times a month in the past couple of months")
  app$expect_values()
  app$expect_screenshot()
})
