#' pred_grouped_sales_rf
#'
#' Predict weekly sales using rf and disaggregate by day
#'
#' @param board
#' @param h: 
#'
#' @return daily prediction
pred_grouped_sales_weekly_rf <- function(board, h) {
  
  if (h %% 7 != 0) {
    print("This algo can only compute weeks ahead")
  }
  
  weekly_board = create_weekly_board(board)
  
  # Create a model for each week ahead
  pred = c()
  for (i in 1:(h/7)) {
    # print(i)
    analytic_weekly_board = create_analytic_weekly_board(weekly_board, i)
    
    rf = ranger::ranger(sales ~ .,
                        data = analytic_weekly_board[week_id != -1, 2:ncol(analytic_weekly_board), with=FALSE])
    
    week_i_pred = predict(rf,
                          analytic_weekly_board[week_id == -1, 2:ncol(analytic_weekly_board), with=FALSE])$predictions
    
    pred <- c(pred, split_week_sales(week_i_pred))
  }
  
  return(pred)
}

