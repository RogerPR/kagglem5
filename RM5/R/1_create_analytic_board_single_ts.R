#' create_analytic_board_single_ts
#'
#' Create analytic board for a single ts, including exogenous variables
#'
#' @param agg_ts
#' @param day_vars_train
#'
#' @return None
# agg_ts = agg_dt[1, ]
# day_vars = day_vars_train
create_analytic_board_single_ts <- function(agg_ts, day_vars, sell_prices, calendar) {
  
  # Initialize analytic board
  board = data.table(day = day_vars, sales = as.matrix(agg_ts[, day_vars, with=FALSE])[1, ])
  
  # Add calendar variables
  calendar = structure_calendar(calendar)
  board = merge(x = board, 
                y = calendar,
                by.x = "day",
                by.y="d",
                all.x=TRUE)
  calendar 
  sell_prices

  
  
  return(agg_dt)
}


