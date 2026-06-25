# State-Year Panel for Merging Correlates of War Data (Gleditsch-Ward)

This a state-year panel in which the Gleditsch-Ward state system is the
population of interest. They are matched, as well as one can, with their
corollaries in the Correlates of War system. Its primary use is merging
in data demarcated in Correlates of War state system codes when the
primary system in use is the Gleditsch-Ward system.

## Usage

``` r
data(gw_cw_panel)
```

## Format

A data frame with the following 6 variables.

- `stateabb`:

  the state abbreviation, which was the greatest source of agreement
  between both data sets

- `year`:

  a numeric vector for the year

- `gwcode`:

  a Gleditsch-Ward state code

- `ccode`:

  a Correlates of War state code

- `gw_name`:

  the state name as it appears in the Gleditsch-Ward data.

- `cw_name`:

  the state name as it appears in the Correlates of War data.

## Details

The `data-raw/` directory on Github contains more information about how
these data were created. The code itself is derived from what
peacesciencer did for its `gw_cow_years` data. It amounts to the
creation of daily data for both systems before doing a "full join" on
where there is the least friction: state abbreviations. This at least
requires the least amount of clean-up.

Use of these data will merge *only* on the state code and year. The
state abbreviations and state names are there for background
information, where necessary/appropriate.

peacesciencer's documentation cautions that the differences between the
two systems are obvious, if often overstated. Merging one into the
other, where possible, will be unproblematic in almost all cases. The
biggest headaches concern German unification, Yemeni unification, and
the overall history of Serbia/Yugoslavia.

Gleditsch-Ward country names for Württemberg, São Tomé and Príncipe, and
Côte d'Ivoire, have manual fixes communicating what the raw data wanted
to communicate in ISO-8859-1 (Latin-1) encoding. Mayeul Kauffmann raised
[this issue on Github](https://github.com/svmiller/isard/issues/1), and
it's an easy fix, but it's worth reiterating that this fix is more
cosmetic or aesthetic than it is practical or functional. You should not
ever lean on a country name for serious data management, and the
admitted gaudiness of this encoding issue is at most an eyesore in the
original data.

## Examples

``` r

str(gw_cw_panel)
#> tibble [20,990 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ stateabb: chr [1:20990] "USA" "USA" "USA" "USA" ...
#>  $ year    : num [1:20990] 1816 1817 1818 1819 1820 ...
#>  $ gwcode  : num [1:20990] 2 2 2 2 2 2 2 2 2 2 ...
#>  $ ccode   : num [1:20990] 2 2 2 2 2 2 2 2 2 2 ...
#>  $ gw_name : chr [1:20990] "United States of America" "United States of America" "United States of America" "United States of America" ...
#>  $ cw_name : chr [1:20990] "United States of America" "United States of America" "United States of America" "United States of America" ...
head(gw_cw_panel)
#> # A tibble: 6 × 6
#>   stateabb  year gwcode ccode gw_name                  cw_name                 
#>   <chr>    <dbl>  <dbl> <dbl> <chr>                    <chr>                   
#> 1 USA       1816      2     2 United States of America United States of America
#> 2 USA       1817      2     2 United States of America United States of America
#> 3 USA       1818      2     2 United States of America United States of America
#> 4 USA       1819      2     2 United States of America United States of America
#> 5 USA       1820      2     2 United States of America United States of America
#> 6 USA       1821      2     2 United States of America United States of America
```
