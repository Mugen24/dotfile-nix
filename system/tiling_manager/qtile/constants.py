from os import getenv
import json
from pathlib import Path
PROJECT_ROOT = Path("/etc/xdg/qtile")
WALLPAPER = PROJECT_ROOT / "background"
CONFIG_PATH = PROJECT_ROOT / "config.json"
SCHEMA = {}
try: 
    # monitors_list: ${config.system.qtile_mod.monitors_list}
    with CONFIG_PATH.open() as fp:
        config = json.load(fp)

    MONITORS: int = int(config["monitors_list"])
    SCHEMA = {
        "primaryLight": config["primaryLight"],
        "primaryDark": config["primaryDark"],
        "secondaryLight": config["secondaryLight"],
        "secondaryDark": config["secondaryDark"],
        "neutral" : config["neutral"],
    }
except Exception as e:
    print(e)
    pass

# try: 
#     path = f"{PROJECT_ROOT}/customisation_config/shallow/schema.json"
#     with open(path, "r") as fp:
#         SCHEMA = json.load(fp)

# except Exception as e:
#     print(e)
#     pass

