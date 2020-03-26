########################################################################################################################
### Main M5 project Viz ################################################################################################
########################################################################################################################
##### Main M5 project Viz ######
devtools::load_all()


### Load Data ----------------------------------------------------------------------------------------------------------
calendar               = loadm5_csv("calendar.csv")
sales_train_validation = loadm5_csv("sales_train_validation.csv")
sell_prices            = loadm5_csv("sell_prices.csv")
sample_submission      = loadm5_csv("sample_submission.csv")

id_vars  = names(sales_train_validation)[1:6]
day_vars = names(sales_train_validation)[7:ncol(sales_train_validation)]

# Split train test
list_train_test = split_train_test_temporally(sales_train_validation, id_vars, day_vars)
train_dt = list_train_test$train_dt
test_dt = list_train_test$test_dt

day_vars_train = names(train_dt)[7:ncol(train_dt)]
day_vars_test = names(test_dt)[7:ncol(test_dt)]

###  Benchmark ---------------------------------------------------------------------------------------------------------
pred = create_vanilla_prediction(list_train_test$train_dt, id_vars)

eval_m5_rmse(pred, list_train_test$test_dt, id_vars)

### Exploration --------------------------------------------------------------------------------------------------------
# Basic instances plotting
prod_ts = dy_format_data(sales_train_validation, day_vars)
dy_plot(prod_ts, 1:3, 365)

# Items by categories
sales_train_validation[, uniqueN(item_id)]
sales_train_validation[, uniqueN(dept_id)]
sales_train_validation[, uniqueN(cat_id)]
sales_train_validation[, uniqueN(store_id)]
sales_train_validation[, uniqueN(state_id)]
sales_train_validation[, .(store_id = unique(store_id)), state_id]
sales_train_validation[, .(dept_id = unique(dept_id)), cat_id]

# Aggregated demand plotting
agg_dt <- aggregate_sales(sales_train_validation, level=c(), day_vars)
dy_plot(dy_format_data(agg_dt, day_vars),  rolling_period=21)

agg_dt <- aggregate_sales(sales_train_validation, level=c("cat_id"), day_vars)
dy_plot(dy_format_data(agg_dt, day_vars),  rolling_period=21)

agg_dt <- aggregate_sales(sales_train_validation, level=c("state_id"), day_vars)
dy_plot(dy_format_data(agg_dt, day_vars),  rolling_period=21)

agg_dt <- aggregate_sales(sales_train_validation, level=c("cat_id", "state_id"), day_vars)
dy_plot(dy_format_data(agg_dt, day_vars),  rolling_period=21)

### Real execution -----------------------------------------------------------------------------------------------------
agg_dt <- aggregate_sales(train_dt, level=c("dept_id", "store_id"), day_vars_train)

create_analytic_board_single_ts()

