library(testthat)

test_that("Component files compile", {
  expect_no_error(source("app/global.R", chdir = TRUE))
  expect_silent(source("app/components/influences.R"))
  expect_silent(source("app/components/time_changes.R"))
  expect_silent(source("app/components/compare_countries.R"))
  expect_silent(source("app/components/vars_by_age.R"))
})
