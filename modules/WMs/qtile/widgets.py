from libqtile import widget
from os import getenv
from config import WALLPAPER, SCHEMA 


def main_widget():
    return [
        widget.Wallpaper(),
        widget.Clock()
    ]

def secondary_widget():
    pass
