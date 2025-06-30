from os import getenv
from libqtile.bar import BarType
from libqtile.widget.clock import Clock
import json
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from constants import *
from qtile_extras import widget
from libqtile import bar
from qtile_extras.widget.decorations import RectDecoration
from libqtile import hook, qtile

SCHEMA = SCHEMA if SCHEMA is not None else {}
DEFAULT = {
    
}

neutral = SCHEMA.get("neutral")
secondaryDark = SCHEMA.get("secondaryDark", "#ffffff")
secondaryLight = SCHEMA.get("secondaryLight", "#ffffff")
primaryDark = SCHEMA.get("primaryDark", "#ffffff")
primaryLight = SCHEMA.get("primaryLight", "#ffffff")
font = "sans"
font_size = 15
transparent = "#00000000"
white = "#ffffff"
black = "#000000"

def rounded_border(color, radius: int | list =10):
    return  {
        "decorations": [
            RectDecoration(colour=color, radius=radius, filled=True)
        ],
        "fontsize": font_size
    }

def powerline(kargs):
    return widget.TextBox(
        text="", # Icon: nf-oct-triangle_left
        fontsize=37,
        padding=-10,
        # background = primaryDark,
        foreground = primaryLight,
        **kargs
    )

def clock(**kargs):
    return widget.Clock(
        foreground = "#ffffff",
        format = "%I:%M %p",
        padding = 10,
        **kargs
    )

def group(**kargs):
    return widget.GroupBox(
        hightlight_method = "text",
        rounded = True,
        border = transparent,
        background = transparent,
        other_screen_border = transparent,
        other_current_screen_border = transparent,
        this_current_screen_border = transparent,
        this_screen_border = transparent,
        # active = transparent, inner color,

        block_highlight_text_color = secondaryLight,
        active = primaryLight,
        inactive = black,
        **kargs
    ) 

def icon(icon, **kargs):
    return widget.TextBox(
        text=icon
    )

def pulse_volume(**kargs):
    return widget.PulseVolume(
        foreground = neutral,
        fmt = "   {}",
        **kargs
    )

def bluetooth(**kargs):
    return widget.Bluetooth(
        foreground = neutral,
        default_text = "  {num_connected_devices}",
        **kargs,
    )

def net(**kargs):
    return widget.Net(
        foreground = neutral,
        format='󰖩  {down:06.2f}{down_suffix:<2} ↓↑ {up:06.2f}{up_suffix:<2}',
        **kargs
    )

def memory(**kargs):
    return widget.Memory(
        foreground = neutral,
        format = ' {MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}',
        **kargs
    )

def cpu(**kargs):
    return widget.CPU(
        foreground = neutral,
        format = '󱌽 {freq_current}GHz {load_percent}%',
        **kargs
    )

def sep(**kargs):
    return widget.Sep(
        **kargs
    )

def systray(**kargs):
    return widget.Systray(
    )

left_round = [10, 0, 0, 10]
right_round = [0, 10, 10, 0]

def main_widget():
    return [
        systray(),
        widget.Spacer(),
        group(),

        widget.Spacer(
        ),

        net(**rounded_border(secondaryLight, left_round), padding=10),
        memory(**rounded_border(secondaryLight, [0,0,0,0]), padding=10),
        cpu(**rounded_border(secondaryLight, right_round), padding=10),

        widget.Spacer(
            length=10
        ),
        
        bluetooth(**rounded_border(primaryLight, left_round), padding=10),
        widget.Spacer(
            length=2,
            background=primaryLight,
        ),
        widget.Sep(text="|", background=primaryLight, foreground=neutral),
        widget.Spacer(
            length=6,
            background=primaryLight
        ),
        pulse_volume(**rounded_border(primaryLight, right_round,), adding=10),

        widget.Spacer(
            length=10
        ),

        clock(**rounded_border(neutral)),
    ]


def secondary_widget():

    return [
        widget.Spacer(),
        group(),
        widget.Spacer(),

            # net(**rounded_border(secondaryLight, left_round), padding=10),
            # memory(**rounded_border(secondaryLight, [0,0,0,0]), padding=10),
            # cpu(**rounded_border(secondaryLight, right_round), padding=10),

            # widget.Spacer(
            #     length=10
            # ),
            # 
            # bluetooth(**rounded_border(primaryLight, left_round), padding=10),
            # widget.Spacer(
            #     length=2,
            #     background=primaryLight,
            # ),
            # widget.Sep(text="|", background=primaryLight, foreground=neutral),
            # widget.Spacer(
            #     length=6,
            #     background=primaryLight
            # ),
            # pulse_volume(**rounded_border(primaryLight, right_round,), adding=10),
            # pulse_volume(**rounded_border(primaryLight), adding=10),

        widget.Spacer(
            length=10
        ),

        clock(**rounded_border(neutral)),
    ]

@hook.subscribe.setgroup
def setgroup():
    for i in range(0, len(qtile.groups)):
        qtile.groups[i].label = " "

    for screen in qtile.screens:
        screen.group.label = " "

screens = [
    Screen(
        wallpaper=WALLPAPER,
        wallpaper_mode='fill',
        bottom=bar.Bar(main_widget(), 30, background="#00000000", margin=5)
     # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
     # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
    )
]

screens = screens + [
    Screen(
        wallpaper=WALLPAPER,
        wallpaper_mode='fill',
        bottom=bar.Bar(secondary_widget(), 25, background="#00000000", margin=5)

     # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
     # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
    )
    for _ in range(1, MONITORS)
]
