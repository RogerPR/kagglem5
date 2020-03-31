import utils
import pandas as pd


def find_open_prod_store_day(train_df, h=28):
    """
    Find if there will be sales for each prod-store-day combination
    :param train_df:
    :param h:
    :return:
    """

    open_ids = pd.DataFrame()

    for i in range(1, h+1):
        open_ids_day = pd.DataFrame({"day_ahead": i, "id": train_df.id, "is_open":True})
        open_ids = pd.concat([open_ids, open_ids_day], axis=0)

    utils.savem5(open_ids, "open_ids")

    return open_ids


def split_prediction(grouped_predictions, open_ids, id_dict):
    """
    Split predictions into store-prod
    :param grouped_predictions:
    :param open_ids:
    :param id_dict:
    :return:
    """

    # Add prediction level ids
    prod_store_predictions = grouped_predictions.merge(id_dict.loc[:, ["id", "ts_id"]], how="left", on=["ts_id"])

    # Add open ids
    prod_store_predictions = prod_store_predictions.merge(open_ids, how="left", on=["id", "day_ahead"])

    # Add weights
    # Compute product weights
    prod_store_predictions = add_product_weights(prod_store_predictions)
    prod_store_predictions["prod_sales"] = prod_store_predictions.pred * prod_store_predictions.weight

    utils.savem5(prod_store_predictions, "prod_store_predictions")
    return prod_store_predictions


def add_product_weights(prod_store_predictions):
    """
    Compute weights to split predictions into store-prod
    :param prod_store_predictions:
    :return:
    """

    # Compute number of active products per day
    grouped = prod_store_predictions.groupby(["is_open", "ts_id", "day_ahead"]).count().reset_index()
    grouped = grouped[[o is True for o in grouped.is_open]].loc[:, ["ts_id", "day_ahead", "id"]]
    grouped.columns = ["ts_id", "day_ahead", "N_active_products"]

    prod_store_predictions = prod_store_predictions.merge(grouped, how="left", on=["ts_id", "day_ahead"])

    # Compute weights
    weights = [1/prod_store_predictions.N_active_products.values[i]
               if bool(prod_store_predictions.is_open.values[i]) else 0
               for i in range(prod_store_predictions.shape[0])]

    prod_store_predictions["weight"] = weights

    prod_store_predictions.drop("N_active_products", axis=1)

    return prod_store_predictions