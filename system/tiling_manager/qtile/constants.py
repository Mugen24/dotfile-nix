from os import getenv
import json
PROJECT_ROOT = getenv("USER_ROOT")
THEME = getenv("USER_THEME")

MONITORS: int = int(getenv("USER_MONITORS_LIST", "1"))
WALLPAPER = f"{PROJECT_ROOT}/modules/WMs/wallpapers/default.jpg"
SCHEMA = {}

if THEME == "shallow":
    WALLPAPER = f"{PROJECT_ROOT}/modules/WMs/wallpapers/neon_shallows.png"
    try: 
        path = f"{PROJECT_ROOT}/customisation_config/shallow/schema.json"
        with open(path, "r") as fp:
            SCHEMA = json.load(fp)
    except:
        pass

