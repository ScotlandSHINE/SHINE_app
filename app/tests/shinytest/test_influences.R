app <- ShinyDriver$new("../../")
app$snapshotInit("test_influences")

app$setInputs(influences = "click")
app$setInputs(`influences-exposure` = "Family helpful")
app$setInputs(`influences-outcome` = "Life satisfaction")
app$snapshot()
