import pandas as pd
from config import DIR_ENV
import pickle


def savem5(obj, file):
    """
    Use pickle to save py object
    :param obj:
    :param file:
    :return:
    """
    file_handler = open(DIR_ENV["py_data"] + "/" + file, 'wb')
    pickle.dump(obj, file_handler)
    file_handler.close()

    return "Obj saved at: " + DIR_ENV["py_data"] + "/" + file


def loadm5(file):
    """
    Use pickle to load py object
    :param file:
    :return:
    """
    file_handler = open(DIR_ENV["py_data"] + "/" + file, 'rb')
    obj = pickle.load(file_handler)
    file_handler.close()

    return obj



def load_inital_data(data_path=None):
    """
    Load project initial csv files
    :param data_path:
    :return:
    """
    if data_path is None:
        data_path = DIR_ENV["data"]

    calendar = pd.read_csv(data_path + "/calendar.csv")
    sales_train_validation = pd.read_csv(data_path + "/sales_train_validation.csv")
    sell_prices = pd.read_csv(data_path + "/sell_prices.csv")
    sample_submission = pd.read_csv(data_path + "/sample_submission.csv")

    return calendar, sales_train_validation, sell_prices, sample_submission


def split_train_test_temporally(df, id_vars, day_vars):
    """
    Take the last 28 days as test set
    :param df:
    :param id_vars:
    :param day_vars:
    :return:
    """

    train_df = df.iloc[:, :-28]
    test_df = pd.concat([df.loc[:, id_vars], df.loc[:, day_vars[-28:]]], axis=1)

    return train_df, test_df