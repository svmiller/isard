
test_that("state_panel() extends to most recent calendar year", {
  expect_equal(max(state_panel(system = "cow", mry = TRUE)$year), as.integer(format(Sys.Date(), "%Y")) - 1)
  expect_equal(max(state_panel(system = "gw", mry = TRUE)$year), as.integer(format(Sys.Date(), "%Y")) - 1)
})


test_that("state_panel() extends to end of system data when mry is FALSE", {
  expect_equal(max(state_panel(system = "cow", mry = FALSE)$year), 2016)
  expect_equal(max(state_panel(system = "gw", mry = FALSE)$year), 2020)
})

test_that("state_panel() doesn't create entries that shouldn't be there", {
  expect_equal(nrow(subset(state_panel(system = 'cow', mry = FALSE), ccode == 40 & year == 1907)), 0)
  expect_equal(nrow(subset(state_panel(system = 'cow', mry = FALSE), ccode == 817 & year == 1976)), 0)
  expect_equal(nrow(subset(state_panel(system = 'cow', mry = FALSE), ccode == 260 & year == 1991)), 0)
  expect_equal(nrow(subset(state_panel(system = 'cow', mry = FALSE), ccode == 817 & year == 1976)), 0)
  expect_equal(nrow(subset(state_panel(system = 'cow', mry = FALSE), ccode == 680 & year == 1991)), 0)
})
