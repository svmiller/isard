# GDP, Population, and GDP per Capita (Gleditsch-Ward System)

These are estimates of democracy for Gleditsch-Ward state system
members.

## Usage

``` r
data(gw_gdppop)
```

## Format

A data frame with the following 8 variables.

- `gwcode`:

  a numeric vector for the Gleditsch-Ward state code

- `year`:

  a numeric vector for the year

- `mrgdppc`:

  a numeric vector for the estimated GDP per capita in a given year. See
  Details.

- `sd_mrgdppc`:

  a numeric vector for the standard deviation of estimated GDP per
  capita in a given year.

- `pwtrgdp`:

  a numeric vector for the estimated real GDP in a given year. See
  Details.

- `sd_pwtrgdp`:

  a numeric vector for the standard deviation of estimated real GDP in a
  given year.

- `pwtpop`:

  a numeric vector for the estimated population in a given year. See
  Details.

- `sd_pwtpop`:

  a numeric vector for the standard deviation of estimated population in
  a given year.

## Details

Based on my reading of Fariss et al. (2022), I think the following
information gathered from their simulations make sense for suggested
defaults. You may want to get their actual simulations if you want
something else, but I think what's included here is good for most use
cases.

For additional clarification, the suggested defaults included in this
data set are:

- GDP per capita: real GDP per capita in prices constant across
  countries and over time (in 2011 international dollars, PPP).

- GDP: expenditure-side real GDP in prices constant across countries and
  over time (in millions of 2017 international dollars, PPP)

- Population: total population (in millions)

The GDP per capita measure is anchored around the Maddison Project
Database. The GDP and population measures are anchored around Penn World
Tables (10.0). You can create a rough estimate of GDP per capita from
the Penn World Table simulations based on the information in this data
set. It's free and the cops can't stop you.

I also honor the authors' suggestion to include the standard deviation
of these estimates as well. Everyone likes a point estimate, but
variation of uncertainty around the estimate is also important.

## References

Please cite Miller (2022) for peacesciencer. Cite Fariss et al. (2022)
for the simulations. You should also cite the Maddison Project Database
(Bolt et al. 2018) and Penn World Table (Feenstra et al. 2015) if that
is the underlying source of the data that Fariss et al. (2022) are
estimating.

Bolt, Jutta, Robert Inklaar, Herman de Jong, and Luiten Janvan Zanden.
2018. "Rebasing 'Maddison': New Income Comparisons and the Shape of
Long-Run Economic Development." *Maddison Project Working paper 10*.

Fariss, Christopher, J., Therese Anders, Jonathan N. Markowitz, and
Miriam Barnum. 2022. "New Estimates of Over 500 Years of Historic GDP
and Population Data." *Journal of Conflict Resolution* 66(3): 553–91.

Feenstra, Robert C., Robert Inklaar, and Marcel P. Timmer. 2015. "The
Next Generation of the Penn World Table." *American Economic Review*
105(10): 3150–82.

## Examples

``` r

str(gw_gdppop)
#> tibble [19,667 × 8] (S3: tbl_df/tbl/data.frame)
#>  $ gwcode    : num [1:19667] 2 2 2 2 2 2 2 2 2 2 ...
#>  $ year      : int [1:19667] 1816 1817 1818 1819 1820 1821 1822 1823 1824 1825 ...
#>  $ mrgdppc   : num [1:19667] 2668 2656 2644 2643 2657 ...
#>  $ sd_mrgdppc: num [1:19667] 411 421 419 422 415 ...
#>  $ pwtrgdp   : num [1:19667] 27951 28557 29150 29640 30452 ...
#>  $ sd_pwtrgdp: num [1:19667] 12015 12256 12349 12462 13244 ...
#>  $ pwtpop    : num [1:19667] 9.16 9.41 9.69 9.95 10.17 ...
#>  $ sd_pwtpop : num [1:19667] 0.69 0.702 0.711 0.714 0.711 ...
head(gw_gdppop)
#> # A tibble: 6 × 8
#>   gwcode  year mrgdppc sd_mrgdppc pwtrgdp sd_pwtrgdp pwtpop sd_pwtpop
#>    <dbl> <int>   <dbl>      <dbl>   <dbl>      <dbl>  <dbl>     <dbl>
#> 1      2  1816   2668.       411.  27951.     12015.   9.16     0.690
#> 2      2  1817   2656.       421.  28557.     12256.   9.41     0.702
#> 3      2  1818   2644.       419.  29150.     12349.   9.69     0.711
#> 4      2  1819   2643.       422.  29640.     12462.   9.95     0.714
#> 5      2  1820   2657.       415.  30452.     13244.  10.2      0.711
#> 6      2  1821   2683.       420.  31981.     13850.  10.5      0.743
```
