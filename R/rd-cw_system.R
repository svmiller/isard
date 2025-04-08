#' States (Correlates of War System)
#'
#' These are the independent states in the Correlates of War system.
#'
#' @format A data frame with the following 5 variables.
#' \describe{
#' \item{\code{ccode}}{a numeric vector for the Correlates of War state code}
#' \item{\code{cw_abb}}{a character vector for the state abbreviation}
#' \item{\code{cw_name}}{a character vector for the state name}
#' \item{\code{start}}{a date for system entry}
#' \item{\code{end}}{a date for system exit}
#' }
#'
#' @details
#'
#' The end column is current as of Dec. 31, 2016. That date is reflected in the
#' `end` column for states still active today.
#'
#' @references
#'
#' Gleditsch, Kristian S. and Michael D. Ward. 1999. "A Revised List of
#' Independent States since the Congress of Vienna."
#' *International Interactions* 25(4): 393–413.
#'
"cw_system"
