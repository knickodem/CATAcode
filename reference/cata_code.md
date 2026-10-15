# Code check-all-that-apply responses into a single variable

In a cross-sectional or longitudinal context, select a set of decision
rules to combine responses to multiple categories from a
check-all-that-apply survey question into a single variable.

## Usage

``` r
cata_code(
  data,
  id,
  categ,
  resp,
  approach,
  endorse = 1,
  time = NULL,
  priority = NULL,
  new.name = "Variable",
  multi.name = "Multiple",
  sep = "-"
)
```

## Arguments

- data:

  A data frame with one row for each `id` (by `time`, if specified) by
  category combination. If `data` are currently in "wide" format where
  each response category is its own column, use
  [`cata_prep()`](https://knickodem.github.io/CATAcode/reference/cata_prep.md)
  first to transform `data`into the proper format. See *Examples*.

- id:

  The column in `data` to uniquely identify each participant.

- categ:

  Unquoted column in `data` indicating the check-all-that apply category
  labels.

- resp:

  Unquoted column in `data` indicating the check-all-that apply
  responses.

- approach:

  One of "all", "counts", "multiple", "priority", or "mode". See
  *Details*.

- endorse:

  The value in `resp` indicating endorsement of the category in `categ`.
  This must be the same for all categories. Common values are 1
  (default), "yes", TRUE, or 2 (for SPSS data).

- time:

  The column in `data` for the time variable; used to reshape
  longitudinal data with multiple observations for each `id`.

- priority:

  Character vector of one or more categories in the `categ` column
  indicating the order to prioritize response categories when `approach`
  is "priority" or "mode".

- new.name:

  Character; column name for the created variable.

- multi.name:

  Character; value given to participants with multiple category
  endorsements when `approach %in% c("multiple", "priority", "mode")`.

- sep:

  Character; separator to use between values when `approach = "all"`.

## Value

`data.frame`

## Details

For all `approach` options, participants with missing data for all
categories in `categ` are removed and not present in the output.

There are two options for `approach` that provide summary information
rather than a single code for each `id`.

`"all"` returns a data frame with `new.name` variable comprised of all
categories endorsed by separated by `sep`. The `time` argument is
ignored when `approach = "all"`. Rather, if `data` includes a column for
time, then output includes a row for each `id` at each time point. This
approach is a useful exploratory first step for identifying all of the
response patterns present in the data.

`"counts"` is only relevant for longitudinal data and returns a data
frame with the number of times an `id` endorsed a category. Only
categories with \>= 1 endorsement are included for a particular `id`. As
with `"all"`, the `time` argument is ignored and instead assumes `data`
is in longer format with a row for each `id` by `time` combination. If
not, the column of counts will be 1 for all rows.

The three remaining options for `approach` produce a single code for
each `id`. The output is a data frame with one row for each `id`. The
choice of approach is only relevant for participants who selected more
than one category whereas participants who only selected one category
will be given that code in the output regardless of which approach is
chosen.

`"multiple"` If participant endorsed multiple categories within or
across time, code as `multi.name`.

`"priority"` Same as "multiple" unless participant endorsed category in
`priority` argument at any point. If so, then code in order specified in
`priority`.

`"mode"` Participant is coded as the category with the mode (i.e., most
common) endorsement across all time points. Ties are coded as as the
value given in `multi.name`. If the `priority` argument is specified,
these categories are prioritized first, followed by the mode response.
The `"mode"` approach is only relevant if `time` is specified. When
`time = NULL` it operates as `"priority"` (when specified) or
`"multiple"`.

## Examples

``` r
# prepare data
data(sources_race)
sources_long <- cata_prep(data = sources_race, id = ID, cols = Black:White, time = Wave)
  
# Identify all unique response patterns
all <- cata_code(sources_long, id = ID, categ = Category, resp = Response,
approach = "all", time = Wave, new.name = "Race_Ethnicity")
unique(all$Race_Ethnicity)
#>  [1] "Hispanic"                                                               
#>  [2] "Hispanic-White"                                                         
#>  [3] "White"                                                                  
#>  [4] "Native_American-White"                                                  
#>  [5] "Multiracial"                                                            
#>  [6] "Black-Native_American"                                                  
#>  [7] "Hispanic-Multiracial"                                                   
#>  [8] "Native_American-Hispanic"                                               
#>  [9] "Black-White"                                                            
#> [10] "Native_American-Hispanic-White"                                         
#> [11] "Black-Native_American-Asian-Hispanic-Pacific_Islander"                  
#> [12] "Black"                                                                  
#> [13] "Native_American"                                                        
#> [14] "Asian"                                                                  
#> [15] "Multiracial-White"                                                      
#> [16] "Black-Native_American-Asian-Hispanic"                                   
#> [17] "Black-Hispanic-White"                                                   
#> [18] "Black-Hispanic"                                                         
#> [19] "Black-Hispanic-Multiracial-White"                                       
#> [20] "Black-Multiracial"                                                      
#> [21] "Black-Native_American-Hispanic-Multiracial"                             
#> [22] "Black-Asian-White"                                                      
#> [23] "Black-Native_American-Asian-Hispanic-Multiracial-Pacific_Islander-White"
#> [24] "Black-Native_American-Hispanic-Multiracial-White"                       
#> [25] "Black-Hispanic-Multiracial"                                             
#> [26] "Native_American-Multiracial"                                            
#> [27] "Black-Pacific_Islander-White"                                           
#> [28] "Native_American-Pacific_Islander-White"                                 
#> [29] "Native_American-Multiracial-White"                                      
#> [30] "Hispanic-Pacific_Islander"                                              
#> [31] "Asian-White"                                                            
#> [32] "Hispanic-Multiracial-White"                                             
#> [33] "Native_American-Hispanic-Multiracial-White"                             
#> [34] "Black-Asian-Hispanic"                                                   
#> [35] "Asian-Multiracial-White"                                                
#> [36] "Pacific_Islander-White"                                                 
#> [37] "Asian-Hispanic"                                                         
#> [38] "Black-Asian-Multiracial"                                                
#> [39] "Pacific_Islander"                                                       
#> [40] "Multiracial-Pacific_Islander"                                           
#> [41] "Black-Asian-Hispanic-White"                                             
#> [42] "Black-Multiracial-White"                                                
#> [43] "Black-Native_American-Hispanic-White"                                   
#> [44] "Asian-Hispanic-White"                                                   
#> [45] "Asian-Pacific_Islander-White"                                           
#> [46] "Black-Native_American-Hispanic"                                         
#> [47] "Native_American-Hispanic-Multiracial"                                   
#> [48] "Black-Native_American-Asian-Multiracial"                                
#> [49] "Black-Pacific_Islander"                                                 
#> [50] "Hispanic-Pacific_Islander-White"                                        
#> [51] "Native_American-Asian-Hispanic-Multiracial-Pacific_Islander-White"      
#> [52] "Black-Asian"                                                            
#> [53] "Black-Asian-Hispanic-Multiracial"                                       
#> [54] "Asian-Hispanic-Multiracial"                                             
#> [55] "Native_American-Asian-White"                                            
#> [56] "Multiracial-Pacific_Islander-White"                                     
#> [57] "Native_American-Asian"                                                  
#> [58] "Black-Native_American-White"                                            
#> [59] "Black-Native_American-Asian-Hispanic-Pacific_Islander-White"            
#> [60] "Asian-Multiracial"                                                      
#> [61] "Black-Native_American-Asian-Hispanic-Multiracial"                       
#> [62] "Asian-Pacific_Islander"                                                 
#> [63] "Asian-Hispanic-Pacific_Islander"                                        
#> [64] "Black-Hispanic-Pacific_Islander-White"                                  
#> [65] "Asian-Multiracial-Pacific_Islander-White"                               
#> [66] "Black-Native_American-Asian-Hispanic-Multiracial-Pacific_Islander"      
#> [67] "Native_American-Hispanic-Pacific_Islander-White"                        
#> [68] "Native_American-Asian-Hispanic"                                         
#> [69] "Black-Native_American-Hispanic-Pacific_Islander"                        
#> [70] "Black-Asian-Hispanic-Multiracial-White"                                 
#> [71] "Black-Native_American-Pacific_Islander-White"                           
#> [72] "Native_American-Asian-Multiracial-White"                                
#> [73] "Black-Native_American-Multiracial-White"                                
#> [74] "Asian-Hispanic-Multiracial-Pacific_Islander-White"                      
#> [75] "Asian-Hispanic-Multiracial-White"                                       
#> [76] "Black-Asian-Hispanic-Multiracial-Pacific_Islander-White"                
#> [77] "Black-Native_American-Asian-Hispanic-Multiracial-White"                 
#> [78] "Asian-Hispanic-Pacific_Islander-White"                                  
#> [79] "Black-Native_American-Asian"                                            
#> [80] "Black-Hispanic-Pacific_Islander"                                        
#> [81] "Native_American-Asian-Hispanic-White"                                   
#> [82] "Black-Asian-Hispanic-Pacific_Islander-White"                            
#> [83] "Black-Native_American-Hispanic-Multiracial-Pacific_Islander-White"      
#> [84] "Black-Native_American-Multiracial"                                      
#> [85] "Native_American-Hispanic-Pacific_Islander"                              
#> [86] "Native_American-Asian-Multiracial"                                      
#> [87] "Black-Native_American-Multiracial-Pacific_Islander-White"               
#> [88] "Native_American-Asian-Hispanic-Multiracial-White"                       

# \donttest{  
# Coding endorsement of multiple categories as "Multiple
multiple <- cata_code(sources_long, id = ID, categ = Category, resp = Response,
approach = "multiple", time = Wave, new.name = "Race_Ethnicity")

# Prioritizing "Native_American" and "Pacific_Islander" endorsements
# If participant endorsed both, they are coded as "Native_American" because it is listed first
# in the priority argument.
priority <- cata_code(sources_long, id = ID, categ = Category, resp = Response,
approach = "priority", time = Wave, new.name = "Race_Ethnicity",
priority = c("Native_American", "Pacific_Islander"))

# Code as category with the most endorsements. In the case of ties, code as "Multiple"
mode <- cata_code(sources_long, id = ID, categ = Category, resp = Response,
approach = "mode", time = Wave, new.name = "Race_Ethnicity")

# Compare frequencies across coding schemes
table(multiple$Race_Ethnicity)
#> 
#>            Asian            Black         Hispanic         Multiple 
#>              128               70             2455             1518 
#>      Multiracial  Native_American Pacific_Islander            White 
#>               55               35               14             2167 
table(priority$Race_Ethnicity)
#> 
#>            Asian            Black         Hispanic         Multiple 
#>              128               70             2455             1034 
#>      Multiracial  Native_American Pacific_Islander            White 
#>               55              445               88             2167 
table(mode$Race_Ethnicity)
#> 
#>            Asian            Black         Hispanic         Multiple 
#>              152              110             2882              665 
#>      Multiracial  Native_American Pacific_Islander            White 
#>              112               65               22             2434 
# }
```
