app <- ShinyDriver$new("../../")
app$snapshotInit("test_vars_by_age")

app$setInputs(vars_by_age = "click")
app$setInputs(`vars_by_age-select_var` = "Watching TV for 2 or more hours a day on weekdays")
app$snapshot()
