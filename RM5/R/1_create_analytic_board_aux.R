#' Structure calendar
#'
#' Prepare the calendar variables (and add) to the format expected by the learning algorithm
#'
#' @param calendar
#'
#' @return calendar
structure_calendar <- function(calendar) {
  # Obvious TODO , much more info to be extracted from calendar
  
  calendar = calendar[, .(d, isweekend = as.numeric(wday %in% c(1, 2)))]
  
  return(calendar)
}


#' create_analytic_board_single_ts
#'
#' Create analytic board for a single ts, including exogenous variables
#'
#' @param agg_ts
#' @param calendar
#'
#' @return None
# agg_ts = agg_dt[ts_id == ts_id[1]]
create_analytic_board_single_ts <- function(agg_ts, calendar) {
  
  # Add calendar variables
  calendar = structure_calendar(calendar)
  board = merge(x = agg_ts[, .(ts_id, day, sales, sell_price)], 
                y = calendar,
                by.x = "day",
                by.y="d",
                all.x=TRUE,
                sort = FALSE)
  
  return(board)
}
