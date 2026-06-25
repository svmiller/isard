# States (Gleditsch-Ward System)

These are the independent states and microstates in the Gleditsch-Ward
system.

## Usage

``` r
data(gw_system)
```

## Format

A data frame with the following 6 variables.

- `gwcode`:

  a numeric vector for the Gleditsch-Ward state code

- `gw_abb`:

  a character vector for the state abbreviation

- `gw_name`:

  a character vector for the state name

- `microstate`:

  a numeric vector for whether the state is a microstate. 1 =
  microstate. 0 = not a microstate

- `start`:

  a date for system entry

- `end`:

  a date for system exit

## Details

The end column is current as of Dec. 31, 2020. That date is reflected in
the `end` column for states still active today.

Country names for Württemberg, São Tomé and Príncipe, and Côte d'Ivoire,
have manual fixes communicating what the raw data wanted to communicate
in ISO-8859-1 (Latin-1) encoding. Mayeul Kauffmann raised [this issue on
Github](https://github.com/svmiller/isard/issues/1), and it's an easy
fix, but it's worth reiterating that this fix is more cosmetic or
aesthetic than it is practical or functional. You should not ever lean
on a country name for serious data management, and the admitted
gaudiness of this encoding issue is at most an eyesore in the original
data.

## References

Gleditsch, Kristian S. and Michael D. Ward. 1999. "A Revised List of
Independent States since the Congress of Vienna." *International
Interactions* 25(4): 393–413.

## Examples

``` r

str(gw_system)
#> tibble [239 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ gwcode    : num [1:239] 2 20 31 40 41 41 42 51 52 53 ...
#>  $ gw_abb    : chr [1:239] "USA" "CAN" "BHM" "CUB" ...
#>  $ gw_name   : chr [1:239] "United States of America" "Canada" "Bahamas" "Cuba" ...
#>  $ microstate: num [1:239] 0 0 0 0 0 0 0 0 0 0 ...
#>  $ start     : Date[1:239], format: "1816-01-01" "1867-07-01" ...
#>  $ end       : Date[1:239], format: "2020-12-31" "2020-12-31" ...
head(gw_system)
#> # A tibble: 6 × 6
#>   gwcode gw_abb gw_name                  microstate start      end       
#>    <dbl> <chr>  <chr>                         <dbl> <date>     <date>    
#> 1      2 USA    United States of America          0 1816-01-01 2020-12-31
#> 2     20 CAN    Canada                            0 1867-07-01 2020-12-31
#> 3     31 BHM    Bahamas                           0 1973-07-10 2020-12-31
#> 4     40 CUB    Cuba                              0 1902-05-20 2020-12-31
#> 5     41 HAI    Haiti                             0 1816-01-01 1915-07-04
#> 6     41 HAI    Haiti                             0 1934-08-15 2020-12-31
```
