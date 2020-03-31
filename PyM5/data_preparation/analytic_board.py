import pandas as pd
import utils


def create_analytic_board(agg_df, calendar):
    """
    Create the analytic board to be used by the prediction algorithms
    :param agg_df:
    :param calendar:
    :return:
    """

    list_ts_ids = agg_df.ts_id.unique()
    analytic_board = pd.DataFrame()

    for id_ts in list_ts_ids:

        board = create_analytic_board_single_ts(agg_df[agg_df.ts_id == id_ts], calendar)
        analytic_board = pd.concat([analytic_board, board], axis=0)

    utils.savem5(analytic_board, "analytic_board")
    return analytic_board


def create_analytic_board_single_ts(agg_ts, calendar):
    """
    Create the analytic board to be used by the prediction algorithms
    :param agg_ts:
    :param calendar:
    :return:
    """

    calendar_vars = prepare_calendar_vars(calendar)

    # Reset index to maintain d_1, d_2 ... order
    agg_ts.loc[:, "order_id"] = [int(d[2:]) for d in agg_ts["d"]]

    keep_vars = ["ts_id", "d", "sales", "sell_price", "order_id"]

    agg_ts = agg_ts.loc[:, keep_vars].merge(calendar_vars, on=["d"])

    agg_ts.sort_values("order_id", inplace=True)
    agg_ts.drop("order_id", inplace=True, axis=1)

    return agg_ts


def prepare_calendar_vars(calendar):
    """
    Prepare relevant calendar variables to be used in the prediction
    :param calendar:
    :return:
    """

    calendar["is_weekend"] = [d in [1, 2] for d in calendar["wday"].values]

    return calendar.loc[:, ["d", "is_weekend"]]
