########################################################################################################################
### Utils script ##########################################################################################s#############
########################################################################################################################

#' Dygraph plot
#'
#' Load data
#'
#' @param file file name
#'
#' @return data table
loadm5 <- function(file) {
  obj = fread(paste0(dir_env$data, "/", file))
  
  return(obj)
}


#' Dygraph plot
#'
#' Creates a TS dygraph plot for the products in ids
#'
#' @param prod_ts product time series object
#' @param ids ids to be plotted
#'
#' @return None
dy_plot <- function(prod_ts, ids, rolling_period=1) {
  ts1 = data.table(cbind(data.table(dates = 1:nrow(prod_ts), prod_ts[, ids, with=FALSE])))
  names(ts1) = c("dates", names(prod_ts)[ids])
  
  dygraph(ts1)
  dyRoller(
    dygraph(
      ts1
    ), rollPeriod = rolling_period
  )
  
}


#' Dygraph plot
#'
#' Creates a TS dygraph plot for the products in ids
#'
#' @param pred 
#' @param real 
#'
#' @return None
eval_m5_rmse <- function(pred, real, id_vars) {
  comp = merge(pred, real, by = id_vars)
  comp[, (id_vars) := NULL]
  
  m1 = as.matrix(comp)[, 1:28]
  m2 = as.matrix(comp)[, 29:56]
  
  return(sqrt(mean((m1 - m2)^2)))
  
}


#' Create vanilla prediction
#'
#' Creates a prediction as the same last 28 days
#'
#' @param pred 
#' @param real 
#'
#' @return None
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
  
  return(list(train_dt = train_dt, test_dt = test_dt))
}














