########################################################################################################################
### Main M5 project Viz ################################################################################################
########################################################################################################################
##### Main M5 project Viz ######
devtools::load_all()


### Load Data ----------------------------------------------------------------------------------------------------------
calendar               = loadm5("calendar.csv")
sales_train_validation = loadm5("sales_train_validation.csv")
sell_prices            = loadm5("sell_prices.csv")
sample_submission      = loadm5("sample_submission.csv")

id_vars  = names(sales_train_validation)[1:6]
day_vars = names(sales_train_validation)[7:ncol(sales_train_validation)]

### Exploration --------------------------------------------------------------------------------------------------------
prod_ts = data.table(t(sales_train_validation[, day_vars, with=FALSE]))
names(prod_ts) = sales_train_validation[, id]

dy_plot(prod_ts, 1:3, 365)

###  Benchmark ---------------------------------------------------------------------------------------------------------
list_train_test = split_train_test_temporally(sales_train_validation, id_vars, day_vars)

pred = create_vanilla_prediction(list_train_test$train_dt, id_vars)

eval_m5_rmse(pred, list_train_test$test_dt, id_vars)
