app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
app$snapshotInit("vars_by_age_app")

app$setInputs(vars_by_age = "click")
app$setInputs(`vars_by_age-select_var` = "Report good or excellent health")
app$setInputs(`vars_by_age-agegrp` = FALSE)
app$snapshot()
