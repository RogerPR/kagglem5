#' Add sell price
#'
#' Add sell price to the sales
#'
#' @param melted_dt
#' @param sell_prices
#' @param calendar
#'
#' @return melted_dt
add_sell_price <- function(melted_dt, sell_prices, calendar) {
  
  # Add day to sell prices
  sell_prices = merge(sell_prices, calendar[, .(wm_yr_wk, d)],
                      by = "wm_yr_wk", all.x=TRUE, allow.cartesian = TRUE)
  
  sell_prices[, wm_yr_wk := NULL]
  melted_dt = merge(x = melted_dt, y = sell_prices, 
                    by.x = c("store_id", "item_id", "day"),
                    by.y = c("store_id", "item_id", "d"), 
                    all.x=TRUE)
  
  # Check melted_dt[is.na(sell_price) & sales != 0] -> Good!
  
  return(melted_dt)
}
