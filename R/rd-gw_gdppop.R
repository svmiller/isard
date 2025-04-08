#' GDP, Population, and GDP per Capita (Gleditsch-Ward System)
#'
#' These are estimates of democracy for Gleditsch-Ward state system members.
#'
#' @format A data frame with the following 8 variables.
#' \describe{
#' \item{\code{gwcode}}{a numeric vector for the Gleditsch-Ward state code}
#' \item{\code{year}}{a numeric vector for the year}
#' \item{\code{mrgdppc}}{a numeric vector for the estimated GDP per capita in a given year. See Details.}
#' \item{\code{sd_mrgdppc}}{a numeric vector for the standard deviation of estimated GDP per capita in a given year.}
#' \item{\code{pwtrgdp}}{a numeric vector for the estimated real GDP in a given year. See Details.}
#' \item{\code{sd_pwtrgdp}}{a numeric vector for the standard deviation of estimated real GDP in a given year.}
#' \item{\code{pwtpop}}{a numeric vector for the estimated population in a given year. See Details.}
#' \item{\code{sd_pwtpop}}{a numeric vector for the standard deviation of estimated population in a given year.}
#' }
#'
#' @details
#'
#' Based on my reading of Fariss et al. (2022), I think the following information
#' gathered from their simulations make sense for suggested defaults. You may
#' want to get their actual simulations if you want something else, but I think
#' what's included here is good for most use cases.
#'
#' For additional clarification, the suggested defaults included in this data set
#' are:
#'
#' - GDP per capita: real GDP per capita in prices constant across countries and
#' over time (in 2011 international dollars, PPP).
#' - GDP: expenditure-side real GDP in prices constant across countries and over
#' time (in millions of 2017 international dollars, PPP)
#' - Population: total population (in millions)
#'
#' The GDP per capita measure is anchored around the Maddison Project Database.
#' The GDP and population measures are anchored around Penn World Tables (10.0).
#' You can create a rough estimate of GDP per capita from the Penn World Table
#' simulations based on the information in this data set. It's free and the cops
#' can't stop you.
#'
#' I also honor the authors' suggestion to include the standard deviation of
#' these estimates as well. Everyone likes a point estimate, but variation of
#' uncertainty around the estimate is also important.
#'
#'
#' @references
#'
#' Please cite Miller (2022) for \pkg{peacesciencer}. Cite Fariss et al. (2022)
#' for the simulations. You should also cite the Maddison Project Database
#' (Bolt et al. 2018) and Penn World Table (Feenstra et al. 2015) if that is
#' the underlying source of the data that Fariss et al. (2022) are estimating.
#'
#' Bolt, Jutta, Robert Inklaar, Herman de Jong, and Luiten Janvan Zanden. 2018.
#' "Rebasing 'Maddison': New Income Comparisons and the Shape of Long-Run Economic
#' Development." *Maddison Project Working paper 10*.
#'
#' Fariss, Christopher, J., Therese Anders, Jonathan N. Markowitz, and Miriam
#' Barnum. 2022. "New Estimates of Over 500 Years of Historic GDP and Population
#' Data." *Journal of Conflict Resolution* 66(3): 553--91.
#'
#' Feenstra, Robert C., Robert Inklaar, and Marcel P. Timmer. 2015. "The Next
#' Generation of the Penn World Table." *American Economic Review* 105(10):
#' 3150--82.
#'
"gw_gdppop"
