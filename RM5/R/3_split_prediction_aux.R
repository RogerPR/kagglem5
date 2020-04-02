#'  Compute weights
#'
#' Compute weights to split predictions into store-prod
#'
#' @param prod_store_predictions
#'
#' @return prod_store_predictions
add_product_weights <- function(prod_store_predictions) {
  
  # prod_store_predictions[is_open == TRUE, weight := 1/.N, by = c("ts_id", "day_ahead")]
  
  prod_store_predictions[is_open == FALSE, weight := 0, by = c("ts_id", "day_ahead")]
  
  
  store_item_weights <- loadm5("store_item_weights")
  prod_store_predictions <- merge(prod_store_predictions, store_item_weights[, .(id, mean_w)], by="id")
  
  prod_store_predictions[is_open == TRUE, weight := mean_w/sum(mean_w), .(ts_id, day_ahead)]
  
  
  return(prod_store_predictions)
}


#'  Fix round
#'
#' Use round distance to modify units until they equal the groupped predition
#'
#' @param prod_store_predictions
#'
#' @return prod_store_predictions
fix_round <- function(prod_store_predictions) {
  
  return(prod_store_predictions)
}
