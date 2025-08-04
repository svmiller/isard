#' States (Gleditsch-Ward System)
#'
#' These are the independent states and microstates in the Gleditsch-Ward system.
#'
#' @format A data frame with the following 6 variables.
#' \describe{
#' \item{\code{gwcode}}{a numeric vector for the Gleditsch-Ward state code}
#' \item{\code{gw_abb}}{a character vector for the state abbreviation}
#' \item{\code{gw_name}}{a character vector for the state name}
#' \item{\code{microstate}}{a numeric vector for whether the state is a microstate. 1 = microstate. 0 = not a microstate}
#' \item{\code{start}}{a date for system entry}
#' \item{\code{end}}{a date for system exit}
#' }
#'
#' @details
#'
#' The end column is current as of Dec. 31, 2020. That date is reflected in the
#' `end` column for states still active today.
#'
#' Country names for Württemberg, São Tomé and Príncipe, and Côte d'Ivoire, have
#' manual fixes communicating what the raw data wanted to communicate in
#' ISO-8859-1 (Latin-1) encoding. Mayeul Kauffmann raised
#' [this issue on Github](https://github.com/svmiller/isard/issues/1), and it's
#' an easy fix, but it's worth reiterating that this fix is more cosmetic or
#' aesthetic than it is practical or functional. You should not ever lean on a
#' country name for serious data management, and the admitted gaudiness of this
#' encoding issue is at most an eyesore in the original data.
#'
#' @references
#'
#' Gleditsch, Kristian S. and Michael D. Ward. 1999. "A Revised List of
#' Independent States since the Congress of Vienna."
#' *International Interactions* 25(4): 393–413.
#'
#' @examples
#'
#' str(gw_system)
#' head(gw_system)
#'
#' @docType data
#' @keywords dataset
#' @name gw_system
#' @usage data(gw_system)
#'
"gw_system"
