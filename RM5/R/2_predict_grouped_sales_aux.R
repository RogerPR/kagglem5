#' pred_grouped_sales_vanilla
#'
#' create pred_grouped_sales_vanilla
#'
#' @param board
#' @param h: 
#'
#' @return daily prediction
pred_grouped_sales_vanilla <- function(board, h) {
  
  pred = tail(board[, sales], 28)
  
  return(pred)
}






