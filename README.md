
# CATAcode <img src="man/figures/logo.PNG" align="right" height="138" alt="" />

**Principled Approaches to Coding Check-All-That-Apply Responses**

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/CATAcode)](https://cran.r-project.org/package=CATAcode)
[![metacrandownloads](https://cranlogs.r-pkg.org/badges/CATAcode)](https://cran.r-project.org/package=CATAcode)
[![metacrandownloads](https://cranlogs.r-pkg.org/badges/grand-total/CATAcode)](https://cran.r-project.org/package=CATAcode)

"Which of the following have happened to you? Check all that apply." 

* Felt overwhelmed by a huge number of response combinations
* Unsure how to use these combinations in an analysis (e.g., regression)
* Had to lump multiple small categories into an uninterpretable "Other" category
* Worried about misrepresenting participants' responses


Check-all-that-apply (CATA) survey items -- alternatively formatted as a set of forced choice yes/no items -- present numerous methodological challenges for
summarizing responses and appropriately representing complex responses in subsequent analyses. Nonetheless, accurately measuring, reporting, 
interpreting, and evaluating responses, particularly regarding participant identity (e.g., race/ethnicity, health conditions), is essential in 
social science, health science, and consumer research.


**CATAcode** provides structured, transparent, and reproducible workflows for handling the challenges posed by CATA responses. The package is specifically designed to assist 
researchers in exploring CATA responses for summary descriptives and preparing CATA items for statistical modeling. Applying this tool to cross-sectional and longitudinal 
data can help enhance the generalizability, transparency, and reproducibility of your research.

**Key Features**

*	Explore all response combinations to CATA items to understand the complexity of participant responses
*	Handle cross-sectional and longitudinal data with specialized functions for each context
*	Multiple coding approaches to choose from (e.g., multiple, priority, and mode)
*	Transparent documentation of subjective coding decisions

You can install the released version of `CATAcode` from CRAN with:

``` r
install.packages("CATAcode")
```

Or the development version from GitHub:

``` r
devtools::install_github("knickodem/CATAcode")
```

Once installed, load the package:

``` r
library(CATAcode)
```

**Why use CATAcode to understand participant demographics?**

*Traditional approaches to CATA demographic items often:*

* Collapse participants with multiple identities into heterogeneous "Other" categories

* Ignore participants who select multiple identities

* Lack transparency in coding decisions

* Fail to capture identity fluidity over time

*CATAcode addresses these issues by:*

* Providing structured exploration of all identity combinations

* Offering principled approaches for category assignment

* Encouraging transparent documentation of subjective decisions

* Supporting both cross-sectional and longitudinal analyses
