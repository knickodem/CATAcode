#' @description
#' Analyzing responses to check-all-that-apply survey items often requires 
#' data transformations and subjective decisions for combining categories. CATAcode
#' contains tools for exploring response patterns, facilitating data transformations, 
#' applying a set of decision rules for coding responses, and summarizing response frequencies.
#' 
#' @name CATAcode
"_PACKAGE"

#' @import rlang
#' @import dplyr
#' @importFrom tidyr pivot_wider
#' @importFrom tidyr pivot_longer
#' @importFrom tidyr unite


if(getRversion() >= "2.15.1")  utils::globalVariables(c("new", "n_time"))