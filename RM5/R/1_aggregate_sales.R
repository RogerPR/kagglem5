#' Aggregate sales
#'
#' Aggregate sales accoring to a level of aggregation. It also melts the dt
#' (Include different aggregation methods????)
#'
#' @param dt
#' @param id_vars
#' @param day_vars
#' @param level: vector of strings corresponding to aggregation levels
#' @param add_sell_prices
#' @param ... Extra params for add_sell_price function
#'
#' @return None
aggregate_sales <- function(dt, id_vars, day_vars, level = c(), add_sell_prices=FALSE, ...) {

  
  # Save grouping relatioship to be used when splitting
  id_dict <- dt[, c("id", level), with=FALSE]
  id_dict[, level_id := apply(dt[, level, with=FALSE], 1, paste0, collapse="_")]
  savem5(id_dict, "id_dict")
  
  melted_dt = melt(dt, id.vars = id_vars, variable.name = "day", value.name = "sales")
  
  if (add_sell_prices) {
    
    melted_dt <- add_sell_price(melted_dt, ...)
    savem5(melted_dt, "maximum_disagregation_dt_with_price")
    
    agg_dt <- melted_dt[, .(sales = sum(sales), sell_price = mean(sell_price, na.rm=TRUE)), by = c(level, "day")]
    
  } else {
    
    agg_dt <- melted_dt[, .(sales = sum(sales)), by = c(level, "day")]
    
  }
  
  agg_dt[, ts_id := apply(agg_dt[, level, with=FALSE], 1, paste0, collapse="_")]
  
  savem5(agg_dt, "agg_dt")
  
  return(agg_dt)

}
  