#' Code check-all-that-apply responses into a single variable
#' 
#' @description
#' In a cross-sectional or longitudinal context, select a set of decision rules 
#' to combine responses to multiple categories from a check-all-that-apply 
#' survey question into a single variable.
#' 
#' @param data A data frame with one row for each `id` (by `time`, if specified) by category combination. 
#' If `data` are currently in "wide" format where each response category is its own column, 
#' use [cata_prep()] first to transform `data`into the proper format. See _Examples_.
#' 
#' @inheritParams cata_prep
#' @param categ Column in `data` indicating the check-all-that apply category labels.
#' @param resp Column in `data` indicating the check-all-that apply responses.
#' @param approach One of "all", "count", "multiple", "priority", or "mode". See _Details_.
#' @param endorse The value in `resp` indicating endorsement of the category in `categ`. This must be the same for all categories.
#' Common values are 1 (default), "yes", TRUE, or 2 (for SPSS data).
#' @param priority Character vector of one or more categories in the `categ` column indicating the order to prioritize 
#' response categories when `approach` is "priority" or "mode".
#' @param new.name Character; column name for the created variable.
#' @param multi.name Character; value given to subjects with multiple category endorsements when `approach %in% c("multiple", "priority", "mode")`.
#' @param sep Character; separator to use between values when `approach = "all"`.
#' 
#' @return `data.frame`
#' 
#' @details 
#' For all `approach` options, subjects with missing data for all categories in `categ` are removed and not present in the output.
#' 
#' There are two options for `approach` that provide summary information rather than a single code for each `id`.
#' 
#' *`"all"` returns a data frame with `new.name` variable comprised of all categories 
#' endorsed by separated by `sep`. The `time` argument is ignored when `approach = "all"`. Rather,
#' if `data` includes a column for time, then output includes a row for each `id` at each time point.
#' This approach is a useful exploratory first step for identifying all of the response patterns present in the data.
#' 
#' *`"counts"` is only relevant for longitudinal data and returns a data frame with the number of times an `id` endorsed
#' a category. Only categories with >= 1 endorsement are included for a particular `id`. As with `"all"`, the `time` argument
#' is ignored and instead assumes `data` is in longer format with a row for each `id` by `time` combination. If not,
#' the column of counts will be 1 for all rows.
#' 
#' The three remaining options for `approach` produce a single code for each `id`. The output is a data frame with one row for each `id`.
#' The choice of approach is only relevant for subjects
#' who selected more than one category whereas subjects who only selected one category will be given
#' that code in the output regardless of which approach is chosen.
#' 
#' *`"multiple"` If subject endorsed multiple categories within or across time, code as `multi.name`.
#' 
#' *`"priority"` Same as "multiple" unless subject endorsed category in `priority` argument at any point. 
#' If so, then code in order specified in `priority`.
#' 
#' *`"mode"` Subject is coded as the category with the mode (i.e., most common) endorsement across all time points. 
#' Ties are coded as "Multiple". If the `priority` argument is specified, these categories are prioritized 
#' first, followed by the mode response. The `"mode"` approach is only relevant is `time` is specified.
#' When `time = NULL` it operates as `"priority"` (when specified) or `"multiple"`.
#' 
#' @examples
#' # prepare data
#' data(sources_race)
#' sources_long <- cata_prep(data = sources_race, id = ID, cols = Black:White, time = Wave)
#'   
#' # Identify all unique response patterns
#' all <- cata_code(sources_long, id = ID, categ = Category, resp = Response,
#' approach = "all", time = Wave, new.name = "Race_Ethnicity")
#' unique(all$Race_Ethnicity)
#'   
#' # Coding endorsement of multiple categories as "Multiple
#' multiple <- cata_code(sources_long, id = ID, categ = Category, resp = Response,
#' approach = "multiple", time = Wave, new.name = "Race_Ethnicity")
#' 
#' # Prioritizing "Native_American" and "Pacific_Islander" endorsements
#' # If participant endorsed both, they are coded as "Native_American" because it is listed first
#' # in the priority argument.
#' priority <- cata_code(sources_long, id = ID, categ = Category, resp = Response,
#' approach = "priority", time = Wave, new.name = "Race_Ethnicity",
#' priority = c("Native_American", "Pacific_Islander"))
#' 
#' # Code as category with the most endorsements. In the case of ties, code as "Multiple"
#' mode <- cata_code(sources_long, id = ID, categ = Category, resp = Response,
#' approach = "mode", time = Wave, new.name = "Race_Ethnicity")
#' 
#' # Compare frequencies across coding schemes
#' table(multiple$Race_Ethnicity)
#' table(priority$Race_Ethnicity)
#' table(mode$Race_Ethnicity)
#' 
#' @export

cata_code <- function(data, id, categ, resp, approach,
                      endorse = 1, time = NULL, priority = NULL,
                      new.name = "Variable", multi.name = "Multiple", sep = "-"){
  
  if(!approach %in% c("all", "counts", "multiple", "priority", "mode")){
    stop("approach must be one of 'all', 'counts' 'multiple', 'priority', or 'mode'")
  }
  
  if(approach == "all"){
    
    # identify categories; used in unite
    cats <- deparse(substitute(categ))
    cats <- unique(data[[cats]])
    
    ## Determines all response categories endorsed
    output <- data %>%
      dplyr::mutate("{{resp}}" := ifelse({{resp}} == endorse, {{categ}}, NA)) %>% # Changing values of endorse to the name it represents
      tidyr::pivot_wider(names_from = {{categ}}, values_from = {{resp}}) %>%      # Pivot data to wider format with one row for each id x time combination
      tidyr::unite(col = "new", all_of(cats), 
                   remove = TRUE, na.rm = TRUE, sep = sep) %>%  # remove = FALSE allows us to examine if the uniting worked
      dplyr::mutate(new = ifelse(new == "", NA, new))           # If subject responded NA to all categories for all waves, code as NA rather than ""
    # Note: Combinations are currently in the order in which the variable appears in data
  }
  
  if(approach %in% c("counts", "multiple", "priority", "mode")){
    
    ## Summarizes each subject's response pattern
    counts <- data %>% 
      dplyr::filter({{resp}} == endorse) %>%                    
      dplyr::group_by({{id}}, {{categ}}) %>%
      dplyr::summarize(n_time = dplyr::n(),   # number of times a subject identified as a certain category
                       .groups = "drop_last") # keeps group by id for use in remaining approaches
    
    if(approach == "counts"){
      return(counts)
    }
    
  }
  
  if(approach == "multiple"){
    
    # Combines multiple categories as multi.name
    output <- counts %>%
      reframe(new = case_when(n() == 1 ~ {{categ}}, # same category across time
                              TRUE ~ multi.name))   # If > 1 category, code as multi.name
  }
  
  if(approach == "priority"){
    
    ## priority argument checks
    if(is.null(priority)){
      stop("Must specify priority argument when approach = 'priority'.")
    }
    categ.name <- deparse(substitute(categ))
    if(!all(priority %in% unique(counts[[categ.name]]))){
      stop("Value(s) in priority argument not found in ", categ.name)
    }
    
    if(length(priority) == 1){
      
      output <- counts %>%
        reframe(new = case_when(sum({{categ}} == priority) > 0 ~ priority, # gave priority at any point, code as priority
                                n() == 1 ~ {{categ}},                      # same category across time
                                TRUE ~ multi.name))                        # If > 1 category, code as multi.name
      
    } else if(length(priority) == 2){
      
      output <- counts %>%
        reframe(new = case_when(sum({{categ}} == priority[[1]]) > 0 ~ priority[[1]], # gave priority at any point, code as priority
                                sum({{categ}} == priority[[2]]) > 0 ~ priority[[2]],
                                n() == 1 ~ {{categ}},                      # same category across time
                                TRUE ~ multi.name))                        # If > 1 category, code as multi.name
      
      
    } else if(length(priority) == 3){
      
      output <- counts %>%
        reframe(new = case_when(sum({{categ}} == priority[[1]]) > 0 ~ priority[[1]], # gave priority at any point, code as priority
                                sum({{categ}} == priority[[2]]) > 0 ~ priority[[2]],
                                sum({{categ}} == priority[[3]]) > 0 ~ priority[[3]],
                                n() == 1 ~ {{categ}},                      # same category across time
                                TRUE ~ multi.name))                        # If > 1 category, code as multi.name
      
    } else if(length(priority) == 4){
      
      output <- counts %>%
        reframe(new = case_when(sum({{categ}} == priority[[1]]) > 0 ~ priority[[1]], # gave priority at any point, code as priority
                                sum({{categ}} == priority[[2]]) > 0 ~ priority[[2]],
                                sum({{categ}} == priority[[3]]) > 0 ~ priority[[3]],
                                sum({{categ}} == priority[[4]]) > 0 ~ priority[[4]],
                                n() == 1 ~ {{categ}},                      # same category across time
                                TRUE ~ multi.name))                        # If > 1 category, code as multi.name
      
    } else {stop("Maximum length of priority argument is 4.")}
    
  }
  
  if(approach == "mode"){
    
    # The mode response with ties coded as multiple
    if(is.null(priority)){
      
      output <- counts %>%
        mutate(n_max = max(n_time)) %>%                                # max frequency within participant
        reframe(new = case_when(n() == 1 ~ {{categ}},                  # same category across time
                                sum(n_time == n_max) > 1 ~ multi.name, # ties - multiple categories with equal frequency
                                n_time == n_max ~ {{categ}},           # multiple categories but one at a higher frequency
                                TRUE ~ "Temp")) %>%                    # categories chosen at lower frequency
        filter(new != "Temp")
      
    } else {
      
      ## priority argument check
      categ.name <- deparse(substitute(categ))
      if(!all(priority %in% unique(counts[[categ.name]]))){
        stop("Value(s) in priority argument not found in ", categ.name)
      }
      
      if(length(priority) == 1){
        
        # A priority, then the mode response with ties coded as multiple 
        output <- counts %>%
          mutate(n_max = max(n_time)) %>%                                # max frequency within participant
          reframe(new = case_when(sum({{categ}} == priority) > 0 ~ priority,    # gave priority at any point, code as priority
                                  n() == 1 ~ {{categ}},                         # same category across time
                                  sum(n_time == n_max) > 1 ~ multi.name,  # ties - multiple categories with equal frequency
                                  n_time == n_max ~ {{categ}},            # multiple categories but one at a higher frequency
                                  TRUE ~ "Temp")) %>%                           # categories chosen at lower frequency
          filter(new != "Temp")
        
      } else if(length(priority) == 2){
        
        # priorities, then the mode response with ties coded as multiple 
        output <- counts %>%
          mutate(n_max = max(n_time)) %>%                                # max frequency within participant
          reframe(new = case_when(sum({{categ}} == priority[[1]]) > 0 ~ priority[[1]], # gave priority at any point, code as priority
                                  sum({{categ}} == priority[[2]]) > 0 ~ priority[[2]],
                                  n() == 1 ~ {{categ}},                                # same category across time
                                  sum(n_time == n_max) > 1 ~ multi.name,         # ties - multiple categories with equal frequency
                                  n_time == n_max ~ {{categ}},                   # multiple categories but one at a higher frequency
                                  TRUE ~ "Temp")) %>%                                  # categories chosen at lower frequency
          filter(new != "Temp")
        
      } else {stop("When approach = 'mode', the maximum length for the priority argument is 2.")}
      
    }
  }
  
  output <- unique(output) # removes redundant rows; produces unique code for each id for multiply, priority, and mode
  names(output)[names(output) == "new"] <- new.name           
  return(output)
  
}
