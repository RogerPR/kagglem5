#' Create wekly board
#'
#' Group sales by week
#'
#' @param board
#'
#' @return weekly board
create_weekly_board <- function(board) {
  
  week_vec = rev(rep(ceiling(nrow(board) / 7):1, each = 7)[1:nrow(board)])
  board[, week_id := week_vec]
  
  
  weekly_board = board[, .(sales = sum(sales)), week_id]
  # Weighted sum on the sell price
  # weekly_board = board[, .(sales = sum(sales), sell_price = sum(sell_price * sales)), week_id]
  # weekly_board[, sell_price := sell_price/sales]
  
  # EXTRA: Save daily weights
  board[, w_sales := sum(sales), week_id]
  board = board[week_id != 1]
  board[, day_id := rep(1:7, times = max(board$week_id)-1)]
  savem5(board[, .(weight_mean = mean(sales/w_sales), weight_sd = sd(sales/w_sales)), day_id], "daily_weights")
  
  return(weekly_board[2:nrow(weekly_board), ])
}


#' create_analytic_weekly_board
#'
#' create analytic weekly board adding rolling averages and values from the past
#'
#' @param weekly_board
#' @param i: weeks ahead
#'
#' @return weekly board
create_analytic_weekly_board <- function(weekly_board, i) {
  
  # Use diff function + sales to obtain lagged sales: 
  # last available week sales
  # í weeks back sales
  # 6 months back sales
  # 12 months back sales
  
  i_weeks_back = i + i
  half_year_weeks_back = 26 - i
  year_weeks_back = 52 - i
  
  analytic_weekly_board <-
    weekly_board[, .(week_id,
                     sales,
                     
                     last_available_week_sales  = c(rep(-1, times=i),
                                                    weekly_board[1:(nrow(weekly_board) - i), sales]),
                     
                     i_weeks_back_sales         = c(rep(-1, times=i_weeks_back),
                                                    weekly_board[1:(nrow(weekly_board) - i_weeks_back), sales]),
                     
                     half_year_weeks_back_sales = c(rep(-1, times=half_year_weeks_back),
                                                    weekly_board[1:(nrow(weekly_board) - half_year_weeks_back), sales]),
                     
                     year_weeks_back_sales      = c(rep(-1, times=year_weeks_back),
                                                    weekly_board[1:(nrow(weekly_board) - year_weeks_back), sales])
                     )]
  
  # Compute rolling avg and sd
  avg_1m  = rep(-1, times = i)
  avg_6m  = rep(-1, times = i)
  avg_12m = rep(-1, times = i)
  sd_1m  = rep(-1, times = i)
  sd_6m  = rep(-1, times = i)
  sd_12m = rep(-1, times = i)
  
  nb = nrow(weekly_board)
  
  for (w in 1:(nb - 52)) {
    avg_1m  = c(avg_1m, weekly_board[(nb - w - 3):(nb - w), mean(sales)])
    avg_6m  = c(avg_6m, weekly_board[(nb - w - 25):(nb - w), mean(sales)])
    avg_12m = c(avg_12m, weekly_board[(nb - w - 51):(nb - w), mean(sales)])
    
    sd_1m  = c(sd_1m, weekly_board[(nb - w - 3):(nb - w), sd(sales)])
    sd_6m  = c(sd_6m, weekly_board[(nb - w - 25):(nb - w), sd(sales)])
    sd_12m = c(sd_12m, weekly_board[(nb - w - 51):(nb - w), sd(sales)])
    
  }
  
  analytic_weekly_board = analytic_weekly_board[year_weeks_back_sales != -1]
  
  # print(dim(analytic_weekly_board))
  # analytic_weekly_board = analytic_weekly_board[(i+1):nrow(analytic_weekly_board)]
  
  analytic_weekly_board[, avg_1m := rev(avg_1m)]
  analytic_weekly_board[, avg_6m := rev(avg_6m)]
  analytic_weekly_board[, avg_12m := rev(avg_12m)]
  
  analytic_weekly_board[, sd_1m := rev(sd_1m)]
  analytic_weekly_board[, sd_6m := rev(sd_6m)]
  analytic_weekly_board[, sd_12m := rev(sd_12m)]
  
  analytic_weekly_board = analytic_weekly_board[avg_1m != -1]
  
  # Add extra row for the prediction
  analytic_weekly_board <- rbind(analytic_weekly_board,
                                 list(
                                      -1,
                                      0,
                                      
                                      weekly_board[nb - i + 1, sales],
                                      weekly_board[nb - i_weeks_back + 1, sales],
                                      weekly_board[nb - half_year_weeks_back + 1, sales],
                                      weekly_board[nb - year_weeks_back + 1, sales],
                                      
                                      weekly_board[(nb - 3):(nb), mean(sales)],
                                      weekly_board[(nb - 25):(nb), mean(sales)],
                                      weekly_board[(nb - 51):(nb), mean(sales)],
                                      
                                      weekly_board[(nb - 3):(nb), sd(sales)],
                                      weekly_board[(nb - 25):(nb), sd(sales)],
                                      weekly_board[(nb - 51):(nb), sd(sales)]
                                      ))
  
  
  return(analytic_weekly_board)
}



#' split_week_sales
#'
#' From week prediction to daily prediction
#'
#' @param week_prediction
#'
#' @return weekly board
split_week_sales = function(week_prediction) {
  
  
  # Using computed daily weights from historic of the  TS
  daily_weights = loadm5("daily_weights")
  splitted_pred = rep(week_prediction, times=7) * daily_weights[, weight_mean]
  
  return(splitted_pred)
}



