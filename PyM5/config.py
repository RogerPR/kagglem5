import yaml

with open("../config.yml") as file:
    cfg = yaml.safe_load(file)

DIR_ENV = dict()
DIR_ENV["root"] = cfg["root"]
DIR_ENV["data"] = cfg["root"] + cfg["data"]["path"]
DIR_ENV["py_data"] = cfg["root"] + cfg["data"]["py_data_path"]
