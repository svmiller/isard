#' Democracy (Correlates of War System)
#'
#' These are estimates of democracy for Correlates of War state system members.
#'
#' @format A data frame with the following 6 variables.
#' \describe{
#' \item{\code{ccode}}{a numeric vector for the Correlates of War state code}
#' \item{\code{year}}{a numeric vector for the year}
#' \item{\code{euds}}{a numeric vector for the extended Unified Democracy Scores (UDS) estimate in a given year}
#' \item{\code{euds_adj}}{a numeric vector for the adjusted, extended UDS estimate in a given year}
#' \item{\code{polity2}}{a numeric vector for the `polity2` score in a given year}
#' \item{\code{v2x_polyarchy}}{a numeric vector for the Varieties of Democracy "polyarchy" estimate in a given year}
#' }
#'
#' @details
#'
#' Extended Unified Democracy Scores (UDS) estimates come from Marquez'
#' \pkg{democracyData} package. That is version 0.5.1. The Varieties of Democracy
#' data are version 15, but also come by way of their R package.
#'
#' The "adjusted" versions of the UDS estimate means that 0 represents the average
#' cut-point for the dichotomous indicators.
#'
#' @references
#'
#' Please cite Miller (2022) for \pkg{peacesciencer}. Beyond that, cite the
#' following, contingent on which democracy estimate you are using.
#'
#' ## Extended Unified Democracy Scores (UDS)
#'
#' Marquez, Xavier. 2016. "A Quick Method for Extending the Unified Democracy
#' Scores" \doi{10.2139/ssrn.2753830}
#'
#' Marquez, Xavier. 2020. "democracyData: A package for accessing and
#' manipulating existing measures of democracy."
#' \url{https://github.com/xmarquez/democracyData}.
#'
#' Pemstein, Daniel, Stephen Meserve, and James Melton. 2010. "Democratic
#' Compromise: A Latent Variable Analysis of Ten Measures of Regime Type."
#' *Political Analysis* 18(4): 426-449.
#'
#' ## Polity5
#'
#' Marshall, Monty G. 2020. "Polity5: Dataset Users' Manual v2018". Center for
#' Systemic Peace. \url{https://www.systemicpeace.org}
#'
#' ## Varieties of Democracy
#'
#' Coppedge, Michael, John Gerring, Carl Henrik Knutsen, Staffan I. Lindberg,
#' Jan Teorell, David Altman, Fabio Angiolillo, Michael Bernhard, Agnes Cornell,
#' M. Steven Fish, Linnea Fox, Lisa Gastaldi, Haakon Gjerløw, Adam Glynn,
#' Ana Good God, Sandra Grahn, Allen Hicken, Katrin Kinzelbach, Joshua Krusell,
#' Kyle L. Marquardt, Kelly McMann, Valeriya Mechkova, Juraj Medzihorsky,
#' Natalia Natsika, Anja Neundorf, Pamela Paxton, Daniel Pemstein,
#' Johannes von Römer, Brigitte Seim, Rachel Sigman, Svend-Erik Skaaning,
#' Jeffrey Staton, Aksel Sundström, Marcus Tannenberg, Eitan Tzelgov,
#' Yi-ting Wang, Felix Wiebrecht, Tore Wig, Steven Wilson and Daniel Ziblatt.
#' 2025. "V-Dem Country-Year Dataset v15" Varieties of Democracy (V-Dem) Project.
#' \doi{10.23696/vdemds25}.
#'
#' Maerz, Seraphine, Amanda Edgell, Sebastian Hellmeier, Nina Ilchenko, Linnea Fox.
#' 'Vdemdata - an R package to load, explore and work with the most recent V-Dem
#' (Varieties of Democracy) and V-Party datasets'. Varieties of Democracy (V-Dem)
#' Project. 2025. \url{https://www.v-dem.net} and
#' \url{https://github.com/vdeminstitute/vdemdata}
#'
"cw_democracy"
