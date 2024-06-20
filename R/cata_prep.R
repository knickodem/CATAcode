#' Prepare data for <[`CATAcode`][cata_code]>
#' 
#' @description
#' A helper function to transform data into a longer format in preparation for use in <[`catacode`][cata_code]>.
#' 
#' @param data A data frame with rows are subjects or subject by time combinations if `time` is specified.
#' @param id Column in `data` to uniquely identify each subject.
#' @param cols <[`tidy-select`][dplyr_tidy_select]> Columns in `data` indicating the check-all-that-apply categories to combine.
#' Endorsement of the category should be indicated by the same value (e.g., 1, "Yes") across all columns included here. Columns are
#' typically dichotomous variables with the two values indicating endorsement or not, but this is not a requirement.
#' @param time Column in `data` for the time variable.
#' @param names_to Character. The name for the new column of categories (i.e., names of the `cols` columns), which is passed to <[`tidyr`][pivot_longer]>.
#' @param values_to Character. The name for the new column of responses (i.e., cell values in the `cols` columns), which is passed to <[`tidyr`][pivot_longer]>.
#' @param ... Optional additional arguments passed to <[`tidyr`][pivot_longer]>.
#' 
#' @return
#' An object of the same type as `data` with one row for each `id` (by `time`, if specified) by response category combination.
#' 
#' @examples
#' sources_race
#' sources_race %>%
#'   cata_prep(id = ID, cols = Black:White, time = Wave)
#' 
#' @export

cata_prep <- function(data, id, cols, time = NULL,
                      names_to = "Category", values_to = "Response", ...){
  data <- data %>%
    dplyr::select({{id}}, {{time}}, {{cols}}) %>% # {{}} is shorthand for !!enquo()
    tidyr::pivot_longer(cols = {{cols}}, names_to = names_to, values_to = values_to, ...) 
}


