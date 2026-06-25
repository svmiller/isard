# States (Correlates of War System)

These are the independent states in the Correlates of War system.

## Usage

``` r
data(cw_system)
```

## Format

A data frame with the following 5 variables.

- `ccode`:

  a numeric vector for the Correlates of War state code

- `cw_abb`:

  a character vector for the state abbreviation

- `cw_name`:

  a character vector for the state name

- `start`:

  a date for system entry

- `end`:

  a date for system exit

## Details

The end column is current as of Dec. 31, 2016. That date is reflected in
the `end` column for states still active today.

## References

Gleditsch, Kristian S. and Michael D. Ward. 1999. "A Revised List of
Independent States since the Congress of Vienna." *International
Interactions* 25(4): 393–413.

## Examples

``` r

str(cw_system)
#> tibble [243 × 5] (S3: tbl_df/tbl/data.frame)
#>  $ ccode  : num [1:243] 2 20 31 40 40 41 41 42 42 51 ...
#>  $ cw_abb : chr [1:243] "USA" "CAN" "BHM" "CUB" ...
#>  $ cw_name: chr [1:243] "United States of America" "Canada" "Bahamas" "Cuba" ...
#>  $ start  : Date[1:243], format: "1816-01-01" "1920-01-10" ...
#>  $ end    : Date[1:243], format: "2016-12-31" "2016-12-31" ...
head(cw_system)
#> # A tibble: 6 × 5
#>   ccode cw_abb cw_name                  start      end       
#>   <dbl> <chr>  <chr>                    <date>     <date>    
#> 1     2 USA    United States of America 1816-01-01 2016-12-31
#> 2    20 CAN    Canada                   1920-01-10 2016-12-31
#> 3    31 BHM    Bahamas                  1973-07-10 2016-12-31
#> 4    40 CUB    Cuba                     1902-05-20 1906-09-25
#> 5    40 CUB    Cuba                     1909-01-23 2016-12-31
#> 6    41 HAI    Haiti                    1859-01-01 1915-07-28
```
