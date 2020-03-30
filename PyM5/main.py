import utils
from data_preparation.aggregate_sales import aggregate_sales
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
agg_df = aggregate_sales(train_df, ['dept_id', 'store_id'], id_vars, sell_prices, calendar)
agg_df = utils.loadm5("agg_df")