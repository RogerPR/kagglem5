import pandas as pd
import utils


def apply_business_rules(prod_store_predictions):
    """
    Apply business rules after prediction
    :param prod_store_predictions:
    :return:
    """

    # TODO
    return prod_store_predictions


def format_predictions(prod_store_predictions):
    """
    Return predictions in submission format
    :param prod_store_predictions:
    :return:
    """

    # Get the relevant variables and cast them
    used_vars = ["id", "day_ahead", "prod_sales"]
    prod_store_predictions_end = prod_store_predictions.loc[:, used_vars].pivot_table(values='prod_sales',
                                                                                      index='id',
                                                                                      columns='day_ahead').reset_index()

    # Rename columns to match submission file
    prod_store_predictions_end.columns = ["id"] + ["F" + str(c) for c in prod_store_predictions_end.columns[1:]]

    utils.savem5(prod_store_predictions_end, "prod_store_predictions_end")
    return prod_store_predictions_end
