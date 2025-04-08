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
#' @references
#'
#' Gleditsch, Kristian S. and Michael D. Ward. 1999. "A Revised List of
#' Independent States since the Congress of Vienna."
#' *International Interactions* 25(4): 393–413.
#'
"gw_system"
