# Prepare data for [`cata_code()`](https://knickodem.github.io/CATAcode/reference/cata_code.md)

A helper function to transform data into a longer format in preparation
for use in
[`cata_code()`](https://knickodem.github.io/CATAcode/reference/cata_code.md).

## Usage

``` r
cata_prep(
  data,
  id,
  cols,
  time = NULL,
  names_to = "Category",
  values_to = "Response",
  ...
)
```

## Arguments

- data:

  A data frame where rows are participants or participant by time
  combinations if `time` is specified.

- id:

  The column in `data` to uniquely identify each participant.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  The columns in `data` indicating the check-all-that-apply categories
  to combine. Endorsement of the category should be indicated by the
  same value (e.g., 1, "Yes") across all columns included here. Columns
  are typically dichotomous variables with the two values indicating
  endorsement or not, but this is not a requirement.

- time:

  The column in `data` for the time variable; used to reshape
  longitudinal data with multiple observations for each `id`.

- names_to:

  Character. The name for the new column of category labels (i.e., names
  of the `cols` columns), which is passed to
  [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html).

- values_to:

  Character. The name for the new column of responses (i.e., cell values
  in the `cols` columns), which is passed to
  [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html).

- ...:

  Optional additional arguments passed to
  [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html).

## Value

An object of the same type as `data` with one row for each `id` (by
`time`, if specified) by response category combination.

## Examples

``` r
data(sources_race)
cata_prep(data = sources_race, id = ID, cols = Black:White, time = Wave)
```
