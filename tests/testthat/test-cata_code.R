####  Tests for cata_code.R  ####
data("sources_race")
sources_long <- cata_prep(sources_race, id = ID, cols = Black:White, time = Wave)
sources1 <-  dplyr::filter(sources_long, Wave == 1)

# testthat::test_that("all",{
#   expect_equal(nrow(cata_prep(sources_race, id = ID, cols = Black:White, time = Wave)), 119399)
#   expect_equal(ncol(cata_prep(sources_race, id = ID, cols = Black:White)), 3)
# })

## when approach = "all" or counts does it matter if time is specified? Nope
# all
all_notime <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response,
                   approach = "all")
all_time <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response, time = Wave,
                      approach = "all")
all.equal(all_notime, all_time)

# counts
counts_notime <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response,
                        approach = "counts")
counts_time <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response, time = Wave,
                      approach = "counts")
all.equal(counts_notime, counts_time)

## what happens to IDs with NA for all categories?
length(unique(sources_long$ID)) # 6465
length(unique(all_time$ID)) #6442; ID with NA to all categories are removed
length(unique(counts_time$ID))  # 6442

# cross-sectional counts
counts_cross <- cata_code(data = sources1, id = ID, categ = Category, resp = Response,
                          approach = "counts")


## should we require specification of time so that way we can ignore extra columns?
all_extracols <- cata_code(data = dplyr::mutate(sources_long, x = 3, y = "yes"), id = ID, categ = Category, resp = Response,
                           approach = "all")
# doesn't matter for counts, and therefore not for multiple, priority, and mode
counts_extracols <- cata_code(data = dplyr::mutate(sources_long, x = 3, y = "yes"), id = ID, categ = Category, resp = Response,
                           approach = "counts")

# Need checks on column type??
if(inherits(counts$new, c("factor", "labelled"))){
  counts$new <- as.character(counts$new)
}

# Can we give a warning if we think time argument should be specified?


multiple_base <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response, time = Wave,
                         approach = "multiple")
priority_base <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response, time = Wave,
                           approach = "priority")
priority_base <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response, time = Wave,
                           approach = "priority", priority = c("In"))
priority_base <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response, time = Wave,
                           approach = "priority", priority = c("Indigenous", "Islander"))
mode_base <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response, time = Wave,
                       approach = "mode")
mode_priority <- cata_code(data = sources_long, id = ID, categ = Category, resp = Response, time = Wave,
                           approach = "priority", priority = c("Indigenous", "Islander"))

lapply(list(multiple_base, priority_base, mode_base, mode_priority), function(x) table(x[["Variable"]]))
