#' create_analytic_board
#'
#' Create analytic board for all ts
#'
#' @param agg_dt
#' @param calendar
#'
#' @return master board
create_analytic_board <- function(agg_dt, calendar) {
  
  ts_ids = unique(agg_dt[, ts_id])
  master_board <- data.table()
  
  for (id in ts_ids) {
    board = create_analytic_board_single_ts(agg_dt[ts_id == id], calendar)
    
    board[, day_order :=  as.numeric(substring(day, 3))]
    board = board[order(day_order)]
    board[, day_order :=  NULL]
    
    master_board = rbind(master_board, board)
  }
  
  savem5(master_board, "master_board")
  
  return(master_board)
}


