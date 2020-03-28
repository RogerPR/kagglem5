########################################################################################################################
### Utils script ##########################################################################################s#############
########################################################################################################################
#' Load data
#'
#' @param file file name
#'
#' @return data table
loadm5_csv <- function(file) {
  obj = fread(paste0(dir_env$data, "/", file))
  
  return(obj)
}


#' Load data
#'
#' @param file file name
#'
#' @return data table
loadm5 <- function(file) {
  obj = readRDS(paste0(dir_env$rdata, "/", file, ".rds"))
  
  return(obj)
}


#' Save data
#'
#' @param file file name
#'
#' @return data table
savem5 <- function(obj, file) {
  saveRDS(obj, paste0(dir_env$rdata, "/", file, ".rds"))
  
  return(NULL)
}


#' Dygraph plot
#'
#' Creates a TS dygraph plot for the products in ids
#'
#' @param prod_ts product time series object
#' @param ids ids to be plotted
#'
#' @return None
dy_plot <- function(prod_ts, ids=NULL, rolling_period=1) {
  
  if (is.null(ids)) { 
    ids <- 1:ncol(prod_ts)
    }
  
  ts1 = data.table(cbind(data.table(dates = 1:nrow(prod_ts), prod_ts[, ids, with=FALSE])))
  names(ts1) = c("dates", names(prod_ts)[ids])
  
  dygraph(ts1)
  dyRoller(
    dygraph(
      ts1
    ), rollPeriod = rolling_period
  )
  
}


#' Format data dygraph
#'
#' Format data to make it friendly with dygraph
#'
#' @param dt 
#' @param day_vars 
#'
#' @return RMSE
dy_format_data <- function(dt, day_vars){
  prod_ts = data.table(t(dt[, day_vars, with=FALSE]))
  names(prod_ts) = dt[, id]
  
  return(prod_ts)
}


#' Compute RMSE
#'
#' Compute RMSE for 28 days prediction
#'
#' @param pred 
#' @param real 
#'
#' @return RMSE
eval_m5_rmse <- function(pred, real) {
  # If there are remaining ID vars, delete them
  pred[, (c("item_id", "dept_id", "cat_id", "store_id", "state_id")) := NULL]
  real[, (c("item_id", "dept_id", "cat_id", "store_id", "state_id")) := NULL]
  
  comp = merge(pred, real, by = "id")
  comp[, id := NULL]
  
  m1 = as.matrix(comp)[, 1:28]
  m2 = as.matrix(comp)[, 29:56]
  
  return(sqrt(mean((m1 - m2)^2)))
  
}


#' Create vanilla prediction
#'
#' Creates a prediction as the same last 28 days
#'
#' @param train 
#' @param id_vars
#'
#' @return prediction
create_vanilla_prediction <- function(train, id_vars) {
 pred_dt = train[, id_vars, with=FALSE]
 pred_dt = data.table(cbind(pred_dt, train[, (ncol(train)-27):ncol(train), with=FALSE]))
 
 return(pred_dt)
}


#' Split train test temproally
#'
#' Take the last 28 days from train out
#'
#' @param train 
#' @param id_vars
#' @param day_vars 
#'
#' @return None
split_train_test_temporally <- function(train, id_vars, day_vars) {
  
  train_dt = train[, 1:(ncol(train)-27), with=FALSE]
  test_dt = data.table(cbind(train[, id_vars, with=FALSE],
                             train[, (ncol(train)-27):ncol(train), with=FALSE]))
  
  savem5(train_dt, "train_dt")
  savem5(test_dt, "test_dt")
  
  return(list(train_dt = train_dt, test_dt = test_dt))
}


#' Aggregate sales
#'
#' Aggregate sales accoring to a level of aggregation
#' (Include different aggregation methods????)
#'
#' @param dt
#' @param day_vars
#' @param level: vector of strings corresponding to aggregation levels
#'
#' @return None
expl_aggregate_sales <- function(dt, day_vars, level = c()) {  
  agg_dt <- dt[, lapply(.SD, sum, na.rm=TRUE), .SDcols = day_vars, by = level]
  
  if (length(level) == 0) {
    agg_dt[, id := "Sales"]
  } else {
    agg_dt[, id := apply(agg_dt[, level, with=FALSE], 1, paste, collapse="_")]
  }
  
  return(agg_dt)
}











