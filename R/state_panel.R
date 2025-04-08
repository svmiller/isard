#' Create a Panel of State-Years from the Correlates of War or Gleditsch-Ward system.
#'
#' @description \code{state_panel()} is a function to create a panel of state-years
#' from one of two major state systems in international relations scholarship.
#'
#' @param system a state system (either "cow" or "gw")
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
#' @examples
#'
#' head(state_panel(), 10)
#' head(state_panel(system='gw'), 10)
#'
#' @export

state_panel <- function(system = "cow") {

  if(system == "cow") {
    the_system <- cw_system
  } else { # system == "gw"
    the_system <- gw_system
  }

  year_list <- Map(seq,  as.numeric(format(the_system$start,'%Y')),
                   as.numeric(format(the_system$end,'%Y')))

  repeated_rows <- rep(seq_len(nrow(the_system)), lengths(year_list))



  if(system == "cow") {

    # Step 3: Create the final data frame
    data <- data.frame(
      ccode = the_system$ccode[repeated_rows],
      cw_name = the_system$cw_name[repeated_rows],
      year = unlist(year_list)
    )

    data <- data[order(data$ccode, data$year), ]
  } else { # system == "gw"

    # Step 3: Create the final data frame
    data <- data.frame(
      gwcode = the_system$gwcode[repeated_rows],
      gw_name = the_system$gw_name[repeated_rows],
      year = unlist(year_list)
    )

    data <- data[order(data$gwcode, data$year), ]
  }


  # Step 4: Sort and drop duplicates
  # data <- data[order(data$gwcode, data$year), ]
  data <- unique(data)

  return(data)

}
