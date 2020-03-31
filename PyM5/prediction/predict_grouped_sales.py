import pandas as pd
import utils

def predict_grouped_sales_loop(analytic_board, h=28):
    """
    Loop and predict over all ts_id
    :param analytic_board:
    :param h: prediction horizon
    :return:
    """

    ts_ids = analytic_board["ts_id"].unique()

    grouped_predictions = pd.DataFrame()
    for id_ts in ts_ids:
        pred = predict_grouped_sales(analytic_board[analytic_board.ts_id == id_ts], h)
        grouped_predictions = pd.concat([grouped_predictions, pred], axis=0)

    utils.savem5(grouped_predictions, "grouped_predictions")
    return grouped_predictions



def predict_grouped_sales(board, h=28):
    """
    Implement prediction on the time series
    :param board:
    :param h: prediction horizon
    :return:
    """
    # TODO

    pred = pd.DataFrame({"ts_id": board.ts_id[0],
                         "day_ahead": list(range(1, h+1)),
                         "pred": board.sales.values[-h:]})

    return pred
