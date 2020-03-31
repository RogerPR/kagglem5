import utils
from data_preparation.aggregate_sales import aggregate_sales
from data_preparation.analytic_board import create_analytic_board
from prediction.predict_grouped_sales import predict_grouped_sales_loop
from prediction.split_prediction import find_open_prod_store_day, split_prediction
from final_format.business_rules import apply_business_rules, format_predictions
# import pandas as pd
# pd.set_option('display.max_rows', 6)


# 1 Prepare data -------------------------------------------------------------------------------------------------------
# Load data
calendar, sales_train_validation, sell_prices, sample_submission = utils.load_inital_data()
id_vars = sales_train_validation.columns[0:6]
day_vars = sales_train_validation.columns[6:]

# Split train test
train_df, test_df = utils.split_train_test_temporally(sales_train_validation, id_vars, day_vars)
day_vars_train = train_df.columns[6:]
day_vars_test = test_df.columns[6:]

# Aggregate df
train_df = utils.loadm5("train_df")
agg_df, id_dict = aggregate_sales(train_df, ['dept_id', 'store_id'], id_vars, sell_prices, calendar)

# Create analytic board
agg_df = utils.loadm5("agg_df")
analytic_board = create_analytic_board(agg_df, calendar)


# 2 Predict sales ------------------------------------------------------------------------------------------------------
# Grouped predictions
analytic_board = utils.loadm5("analytic_board")
grouped_predictions = predict_grouped_sales_loop(analytic_board)

# Find open prod-store
train_df = utils.loadm5("train_df")
open_ids = find_open_prod_store_day(train_df)

# Split prediction
grouped_predictions = utils.loadm5("grouped_predictions")
open_ids = utils.loadm5("open_ids")
id_dict = utils.loadm5("id_dict")
prod_store_predictions = split_prediction(grouped_predictions, open_ids, id_dict)


# 3 Business rules and format ------------------------------------------------------------------------------------------
prod_store_predictions = utils.loadm5("prod_store_predictions")

# Business rules
prod_store_predictions = apply_business_rules(prod_store_predictions)

# Final submission format
prod_store_predictions_end = format_predictions(prod_store_predictions)

# Eval
prod_store_predictions_end = utils.loadm5("prod_store_predictions_end")
test_df = utils.loadm5("test_df")
print(utils.eval_m5_rmse(prod_store_predictions_end, test_df))
