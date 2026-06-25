# Create a Panel of State-Years from the Correlates of War or Gleditsch-Ward system.

`state_panel()` is a function to create a panel of state-years from one
of two major state systems in international relations scholarship.

## Usage

``` r
state_panel(system = "cow", mry = TRUE)
```

## Arguments

- system:

  a state system (either "cow" or "gw")

- mry:

  logical, defaults to TRUE. If TRUE, the panel created extends to the
  most recently concluded calendar year. If FALSE, the panel created
  ends at the year of last update. See details section for more.

## Value

`state_panel()` returns a data frame of state years corresponding with
either the Correlates of War or the Gleditsch-Ward system.

## Details

This function leans on `cw_system` and `gw_system` in this package.

The Correlates of War system's last year is 2016. The Gleditsch-Ward
system's last year is 2020. This information matters for the `mry`
argument in the function.

## Examples

``` r

head(state_panel(), 10)
#>    ccode                  cw_name year
#> 1      2 United States of America 1816
#> 2      2 United States of America 1817
#> 3      2 United States of America 1818
#> 4      2 United States of America 1819
#> 5      2 United States of America 1820
#> 6      2 United States of America 1821
#> 7      2 United States of America 1822
#> 8      2 United States of America 1823
#> 9      2 United States of America 1824
#> 10     2 United States of America 1825
head(state_panel(system='gw'), 10)
#>    gwcode                  gw_name year
#> 1       2 United States of America 1816
#> 2       2 United States of America 1817
#> 3       2 United States of America 1818
#> 4       2 United States of America 1819
#> 5       2 United States of America 1820
#> 6       2 United States of America 1821
#> 7       2 United States of America 1822
#> 8       2 United States of America 1823
#> 9       2 United States of America 1824
#> 10      2 United States of America 1825
```
