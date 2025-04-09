#' Create a Panel of State-Years from the Correlates of War or Gleditsch-Ward system.
#'
#' @description \code{state_panel()} is a function to create a panel of state-years
#' from one of two major state systems in international relations scholarship.
#'
#' @param system a state system (either "cow" or "gw")
#' @param mry logical, defaults to TRUE. If TRUE, the panel created extends to
#' the most recently concluded calendar year. If FALSE, the panel created ends
#' at the year of last update. See details section for more.
#'
#' @return
#'
#' \code{state_panel()} returns a data frame of state years corresponding with
#' either the Correlates of War or the Gleditsch-Ward system.
#'
#' @details
#'
#' This function leans on `cw_system` and `gw_system` in this package.
#'
#' The Correlates of War system's last year is 2016. The Gleditsch-Ward system's
#' last year is 2020. This information matters for the `mry` argument in the
#' function.
#'
#' @examples
#'
#' head(state_panel(), 10)
#' head(state_panel(system='gw'), 10)
#'
#' @export

state_panel <- function(system = "cow", mry = TRUE) {

  if (!system %in% c("cow", "gw")) {
    stop('`system` must be either Correlates of War ("cow") or Gleditsch-Ward ("gw").', call. = FALSE)
  }

  if(system == "cow") {
    the_system <- cw_system

        if(mry == TRUE) { # FYI, this works only under two conditions that are satisfied here:
          # 1) no state "died" in 2016, and 2) the last year in question is 2016.

          the_system$year <- format(the_system$end, "%Y")
          the_system$day <- format(the_system$end, "%d")
          the_system$month <- format(the_system$end, "%m")
          the_system$year <- ifelse(the_system$year == "2016", as.integer(format(Sys.Date(), "%Y")) - 1, the_system$year)
          the_system$end <- as.Date(paste0(the_system$year, "-", the_system$month, "-", the_system$day))
          the_system$year <- the_system$day <- the_system$month <- NULL


        }


  } else { # system == "gw"
    the_system <- gw_system

    if(mry == TRUE) { # FYI, this works only under two conditions that are satisfied here:
      # 1) no state "died" in 2020, and 2) the last year in question is 2020.

      the_system$year <- format(the_system$end, "%Y")
      the_system$day <- format(the_system$end, "%d")
      the_system$month <- format(the_system$end, "%m")
      the_system$year <- ifelse(the_system$year == "2020", as.integer(format(Sys.Date(), "%Y")) - 1, the_system$year)
      the_system$end <- as.Date(paste0(the_system$year, "-", the_system$month, "-", the_system$day))
      the_system$year <- the_system$day <- the_system$month <- NULL


    }

  }

  ylist <- Map(seq, as.numeric(format(the_system$start, "%Y")),
                   as.numeric(format(the_system$end, "%Y")))

  rows <- rep(seq_len(nrow(the_system)), lengths(ylist))



  if(system == "cow") {

    data <- data.frame(
      ccode = the_system$ccode[rows],
      cw_name = the_system$cw_name[rows],
      year = unlist(ylist)
    )

    data <- data[order(data$ccode, data$year), ]
  } else { # system == "gw"


    data <- data.frame(
      gwcode = the_system$gwcode[rows],
      gw_name = the_system$gw_name[rows],
      year = unlist(ylist)
    )

    data <- data[order(data$gwcode, data$year), ]
  }

  data <- unique(data)

  return(data)

}
