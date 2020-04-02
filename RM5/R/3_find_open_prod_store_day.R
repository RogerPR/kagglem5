#' Find open prod/store/day
#'
#' Find if there will be sales for each prod-store-day combination
#'
#' @param train_dt
#' @param h
#'
#' @return 
find_open_prod_store_day <- function(train_dt, h=28) {
  # TODO
  open_ids <- list()
  id_sales = rowSums(as.matrix(train_dt[, (ncol(train_dt) - 100):ncol(train_dt), with=FALSE]))
  
  for (i in 1:h) {
    open_ids[[i]] <- train_dt[id_sales > 80, id]
  }
  
  savem5(open_ids, "open_ids")
  
  return(open_ids)
}
