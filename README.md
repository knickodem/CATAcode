
# CATAcode <img src="man/figures/logo.PNG" align="right" height="138" alt="" />

**Principled Approaches to Coding Check-All-That-Apply Responses**

Accurately measuring, reporting, interpreting, and evaluating identity categories in social science research is essential. However, check-all-that-apply (CATA) responses 
(e.g., race/ethnicity, gender identity, sexual orientation, health conditions) present methodological challenges due to the large permutations of categories and the 
fluctuating salience of intersecting responses across time and contexts. These challenges can hinder the validity of quantitative studies, especially those addressing social 
identity differences. 

`CATAcode` provides structured, transparent, and reproducible workflows for handling the challenges posed by CATA responses. The package is specifically designed to assist 
researchers in exploring CATA responses for summary descriptives and preparing CATA items for statistical modeling. Applying this tool to cross-sectional and longitudinal 
data can help enhance the generalizability, transparency, and reproducibility of your research.

**Key Features**

•	Explore all identity combinations in your data to understand the complexity of participant responses

•	Handle cross-sectional and longitudinal data with specialized functions for each context

•	Multiple coding approaches to choose from (e.g., multiple, priority, and mode)

•	Transparent documentation of subjective coding decisions

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

**Why use CATAcode?**

*Traditional approaches to CATA demographic items often:*

•	Collapse multiracial participants into heterogeneous "Other" categories

•	Ignore participants who select multiple identities

•	Lack transparency in coding decisions

•	Fail to capture identity fluidity over time

*CATAcode addresses these issues by:*

•	Providing structured exploration of all identity combinations

•	Offering principled approaches for category assignment

•	Encouraging transparent documentation of subjective decisions

•	Supporting both cross-sectional and longitudinal analyses
