#' State-Year Panel for Merging G-W Data (Correlates of War)
#'
#' This a state-year panel in which the Correlates of War state system is the
#' population of interest. They are matched, as well as one can, with their
#' corollaries in the Gleditsch-Ward system. Its primary use is merging in data
#' demarcated in Gleditsch-Ward state system codes when the primary system in
#' use is the Correlates of War system.
#'
#' @format A data frame with the following 6 variables.
#' \describe{
#' \item{\code{stateabb}}{the state abbreviation, which was the greatest source of agreement between both data sets}
#' \item{\code{year}}{a numeric vector for the year}
#' \item{\code{gwcode}}{a Gleditsch-Ward state code}
#' \item{\code{ccode}}{a Correlates of War state code}
#' \item{\code{gw_statename}}{the state name as it appears in the Gleditsch-Ward data.}
#' \item{\code{cw_statename}}{the state name as it appears in the Correlates of War data.}
#' }
#'
#' @details
#'
#' The `data-raw/` directory on Github contains more information about how
#' these data were created. The code itself is derived from what \pkg{peacesciencer}
#' did for its `cow_gw_years` data. It amounts to the creation of daily data for
#' both systems before doing a "full join" on where there is the least friction:
#' state abbreviations. This at least requires the least amount of clean-up.
#'
#' Use of these data will merge *only* on the state code and year. The state
#' abbreviations and state names are there for background information, where
#' necessary/appropriate.
#'
#' \pkg{peacesciencer}'s documentation cautions that the differences between the
#' two systems are obvious, if often overstated. Merging one into the other,
#' where possible, will be unproblematic in almost all cases. The biggest
#' headaches concern German unification, Yemeni unification, and the overall
#' history of Serbia/Yugoslavia.
#'
"cw_gw_panel"
