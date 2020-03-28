#' Predict grouped sales loop
#'
#' Predict grouped sales for each TS
#'
#' @param master_board
#' @param h: pred horizon
#'
#' @return predictions
predict_grouped_sales_loop <- function(master_board, h=28) {
  ts_ids = unique(master_board[, ts_id])
  
  grouped_predictions = data.table()
  
  for (id in ts_ids) {
    board = master_board[ts_id == id]
    
    ts_pred = predict_grouped_sales(board, h)
    grouped_predictions = rbind(grouped_predictions, 
                                data.table(ts_id = id, day_ahead = 1:h, pred = ts_pred))
  }
  
  savem5(grouped_predictions, "grouped_predictions")
  
  return(grouped_predictions)
}


#' Predict grouped sales
#'
#' Predict grouped sales
#'
#' @param board
#'
#' @return predictions
predict_grouped_sales <- function(board, h=28) {
  # TODO - implement prediction algo
  pred = tail(board[, sales], 28)
  
  return(pred)
}
