####  Tests for cata_prep.R  ####
data("sources_race")

testthat::test_that("basics",{
  expect_equal(nrow(cata_prep(sources_race, id = ID, cols = Black:White, time = Wave)), 119399)
  expect_equal(ncol(cata_prep(sources_race, id = ID, cols = Black:White)), 3)
})

testthat::test_that("names and values",{
  expect_equal(names(cata_prep(sources_race, id = ID, cols = Black:White, time = Wave,
                               names_to = "whatever"))[[3]], "whatever")
  expect_equal(names(cata_prep(sources_race, id = ID, cols = Black:White, time = Wave,
                               values_to = "whatever"))[[4]], "whatever")
})

testthat::test_that("pass arguments",{
  expect_equal(nrow(cata_prep(sources_race, id = ID, cols = Black:White,
                              time = Wave, values_drop_na = TRUE)), 19871)
})
