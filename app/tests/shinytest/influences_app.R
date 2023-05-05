app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
app$snapshotInit("influences_app")

app$setInputs(influences = "click")
app$setInputs(`influences-exposure` = "Family helpful")
app$setInputs(`influences-outcome` = "Life satisfaction")
app$snapshot()
