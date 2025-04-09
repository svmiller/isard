
test_that("state_panel() extends to most recent calendar year", {
  expect_equal(max(state_panel(system = "cow", mry = TRUE)$year), as.integer(format(Sys.Date(), "%Y")) - 1)
  expect_equal(max(state_panel(system = "gw", mry = TRUE)$year), as.integer(format(Sys.Date(), "%Y")) - 1)
})
