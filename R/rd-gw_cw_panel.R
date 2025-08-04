#' State-Year Panel for Merging Correlates of War Data (Gleditsch-Ward)
#'
#' This a state-year panel in which the Gleditsch-Ward state system is the
#' population of interest. They are matched, as well as one can, with their
#' corollaries in the Correlates of War system. Its primary use is merging in data
#' demarcated in Correlates of War state system codes when the primary system in
#' use is the Gleditsch-Ward system.
#'
#' @format A data frame with the following 6 variables.
#' \describe{
#' \item{\code{stateabb}}{the state abbreviation, which was the greatest source of agreement between both data sets}
#' \item{\code{year}}{a numeric vector for the year}
#' \item{\code{gwcode}}{a Gleditsch-Ward state code}
#' \item{\code{ccode}}{a Correlates of War state code}
#' \item{\code{gw_name}}{the state name as it appears in the Gleditsch-Ward data.}
#' \item{\code{cw_name}}{the state name as it appears in the Correlates of War data.}
#' }
#'
#' @details
#'
#' The `data-raw/` directory on Github contains more information about how
#' these data were created. The code itself is derived from what \pkg{peacesciencer}
#' did for its `gw_cow_years` data. It amounts to the creation of daily data for
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
#' Gleditsch-Ward country names for Württemberg, São Tomé and Príncipe, and Côte
#' d'Ivoire, have manual fixes communicating what the raw data wanted to
#' communicate in ISO-8859-1 (Latin-1) encoding. Mayeul Kauffmann raised
#' [this issue on Github](https://github.com/svmiller/isard/issues/1), and it's
#' an easy fix, but it's worth reiterating that this fix is more cosmetic or
#' aesthetic than it is practical or functional. You should not ever lean on a
#' country name for serious data management, and the admitted gaudiness of this
#' encoding issue is at most an eyesore in the original data.
#'
#' @examples
#'
#' str(gw_cw_panel)
#' head(gw_cw_panel)
#'
#' @docType data
#' @keywords dataset
#' @name gw_cw_panel
#' @usage data(gw_cw_panel)

"gw_cw_panel"
