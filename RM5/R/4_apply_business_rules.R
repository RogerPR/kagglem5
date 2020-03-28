#' Aply business rules
#'
#' Apply hand made corrections to the predictions
#'
#' @param prod_store_predictions
#'
#' @return master board
apply_business_rules <- function(prod_store_predictions) {
  # TODO
  
  # Convert to desired format
  prod_store_predictions_end <- dcast(prod_store_predictions[, .(id, day_ahead, prod_sales),],
                                      id~day_ahead, value.var = "prod_sales")
  names(prod_store_predictions_end) <- c("id", paste0("F", 1:max(prod_store_predictions[, day_ahead])))
  
  savem5(prod_store_predictions_end, "prod_store_predictions_end")
  
  return(prod_store_predictions_end)
}
