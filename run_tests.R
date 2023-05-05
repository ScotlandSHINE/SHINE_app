library(testthat)
library(shinytest)

test_that("Application works", {
  expect_pass(testApp("app", compareImages = TRUE))
})
