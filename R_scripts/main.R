########################################################################################################################
### Main M5 project Viz ################################################################################################
########################################################################################################################
##### Main M5 project Viz ######
devtools::load_all()

### Load Data ###
calendar               = loadm5("calendar.csv")
sales_train_validation = loadm5("sales_train_validation.csv")
sell_prices            = loadm5("sell_prices.csv")
sample_submission      = loadm5("sample_submission.csv")

### Exploration
prod_ts = data.table(t(sales_train_validation[, 7:ncol(sales_train_validation)]))
names(prod_ts) = sales_train_validation[, id]

dy_plot(prod_ts, 1:3, 365)
