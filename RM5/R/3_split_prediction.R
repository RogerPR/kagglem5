#' Split prediction
#'
#' Split predictions into store-prod
#'
#' @param grouped_predictions
#' @param open_ids
#' @param id_dict
#'
#' @return master board
split_prediction <- function(grouped_predictions, open_ids, id_dict) {
  
  # Open ids for each day in data table format
  open_id_dt <- data.table()
  for (i in 1:length(open_ids)) {
    day_dt <- data.table(day_ahead = i, id = open_ids[[i]], is_open = TRUE)
    open_id_dt <- rbind(open_id_dt, day_dt)
    
  }
  
  # Add prod - store id to the grouped prediction
  prod_store_predictions <-  merge(x = grouped_predictions,
                                   y = id_dict[, .(id, level_id)],
                                   by.x = "ts_id",
                                   by.y = "level_id",
                                   allow.cartesian = TRUE)
  
  # Add open prod-store
  prod_store_predictions <- merge(x = prod_store_predictions, 
                                  y = open_id_dt,
                                  by=c("id", "day_ahead"),
                                  all.x=TRUE)
  
  # Compute product weights
  prod_store_predictions <- add_product_weights(prod_store_predictions)
  prod_store_predictions[, prod_sales := pred * weight]
  
  # No need to round?
  # prod_store_predictions[, prod_sales := round(pred * weight, 0)]
  # prod_store_predictions <- fix_round(prod_store_predictions)
    
  savem5(prod_store_predictions, "prod_store_predictions")
  
  return(prod_store_predictions)
}
