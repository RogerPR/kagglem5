import pandas as pd
import numpy as np
import utils

def aggregate_sales(df, level, id_vars, sell_prices, calendar):
    """
    Aggregate sales accoring to a level of aggregation. It also melts the dt
    :param df:
    :param level:
    :param id_vars:
    :param sell_prices:
    :param calendar:
    :return: grouped_df
    """

    # Save grouping relationship to be used when splitting
    id_dict = df.loc[:, ["id"] + level]
    id_dict["ts_id"] = id_dict.loc[:, level].apply(lambda row: '_'.join(row.values), axis=1)
    utils.savem5(id_dict, "id_dict")

    # Add day to prices
    sell_prices = sell_prices.merge(calendar.loc[:, ["wm_yr_wk", "d"]], on=["wm_yr_wk"])
    sell_prices.drop("wm_yr_wk", axis=1, inplace=True)

    # Melt sales and add sell price per day
    melted_df = pd.melt(df, id_vars, var_name="d", value_name="sales")
    melted_df = melted_df.merge(sell_prices, how="left", on=["store_id", "item_id", "d"])

    # Group by level (always add day to the grouping)
    grouping_func = {'sales': 'sum', 'sell_price': np.nanmean}
    agg_df = melted_df.groupby(level + ["d"]).agg(grouping_func).reset_index()
    agg_df["ts_id"] = agg_df.loc[:, level].apply(lambda row: '_'.join(row.values), axis=1)

    utils.savem5(agg_df, "agg_df")
    return agg_df, id_dict
