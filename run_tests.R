library(testthat)
library(shinytest)

test_that("Application works", {
  expect_pass(testApp("app", compareImages = TRUE))
})


test_that("Component files compile", {
  expect_silent(source("app/components/influences.R"))
  expect_silent(source("app/components/time_changes.R"))
  expect_silent(source("app/components/compare_countries.R"))
  expect_silent(source("app/components/vars_by_age.R"))
})
