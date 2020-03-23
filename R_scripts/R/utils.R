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
dy_plot <- function(prod_ts, ids, rolling_period=1){
  ts1 = data.table(cbind(data.table(dates = 1:nrow(prod_ts), prod_ts[, ids, with=FALSE])))
  names(ts1) = c("dates", names(prod_ts)[ids])
  
  dygraph(ts1)
  dyRoller(
    dygraph(
      ts1
    ), rollPeriod = rolling_period
  )
  
}