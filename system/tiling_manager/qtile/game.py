from libqtile.config import Match, Group, Key
from libqtile.lazy import lazy
import re 

"""
STEAM

_NET_WM_STATE(ATOM) = 
_NET_FRAME_EXTENTS(CARDINAL) = 2, 2, 2, 2
_NET_WM_DESKTOP(CARDINAL) = 7
WM_STATE(WM_STATE):
		window state: Normal
		icon window: 0x0
XdndProxy(WINDOW): window id # 0x220000f
_VARIABLE_REFRESH(CARDINAL) = 1
_NET_WM_ICON(CARDINAL) = 	Icon (128 x 128):
	(not shown)

STEAM_GAME(CARDINAL) = 769
XdndAware(ATOM) = BITMAP
_NET_WM_NAME(UTF8_STRING) = "Steam"
WM_NAME(UTF-8) = "Steam"
WM_PROTOCOLS(ATOM): protocols  WM_DELETE_WINDOW, WM_TAKE_FOCUS, _NET_WM_PING
_NET_WM_WINDOW_TYPE(ATOM) = _NET_WM_WINDOW_TYPE_NORMAL
_NET_WM_PID(CARDINAL) = 158210
WM_LOCALE_NAME(STRING) = "en_GB.UTF-8"
WM_CLASS(STRING) = "steamwebhelper", "steam"
WM_HINTS(WM_HINTS):
		Client accepts input or input focus: True
		window id # of group leader: 0x3bc2b82
WM_NORMAL_HINTS(WM_SIZE_HINTS):
		user specified location: 3840, 0
		program specified minimum size: 1010 by 600
WM_CLIENT_MACHINE(STRING) = "nixos"
_MOTIF_WM_HINTS(_MOTIF_WM_HINTS) = 0x2, 0x0, 0x0, 0x0, 0x0


OVERWATCH

_NET_FRAME_EXTENTS(CARDINAL) = 0, 0, 0, 0
_NET_WM_DESKTOP(CARDINAL) = 7
WM_STATE(WM_STATE):
		window state: Normal
		icon window: 0x0
_NET_WM_ICON(CARDINAL) = 	Icon (32 x 32):
_NET_WM_BYPASS_COMPOSITOR(CARDINAL) = 0
_NET_WM_STATE(ATOM) = _NET_WM_STATE_FULLSCREEN
_NET_WM_NAME(UTF8_STRING) = "Overwatch"
WM_ICON_NAME(STRING) = "Overwatch"
WM_NAME(STRING) = "Overwatch"
_WINE_HWND_EXSTYLE(CARDINAL) = 262168
_WINE_HWND_STYLE(CARDINAL) = 335544320
WM_HINTS(WM_HINTS):
		Client accepts input or input focus: True
		Initial state is Normal State.
		bitmap id # to use for icon: 0x460001d
		bitmap id # of mask for icon: 0x460001f
		window id # of group leader: 0x4c00001
_NET_WM_WINDOW_TYPE(ATOM) = _NET_WM_WINDOW_TYPE_NORMAL
_MOTIF_WM_HINTS(_MOTIF_WM_HINTS) = 0x3, 0x26, 0x0, 0x0, 0x0
WM_NORMAL_HINTS(WM_SIZE_HINTS):
		program specified location: 3840, 0
		window gravity: Static
_NET_WM_USER_TIME_WINDOW(WINDOW): window id # 0x4600012
XdndAware(ATOM) = BITMAP
_NET_WM_PID(CARDINAL) = 161584
WM_LOCALE_NAME(STRING) = "en_US.UTF-8"
WM_CLIENT_MACHINE(STRING) = "nixos"
WM_CLASS(STRING) = "steam_app_2357570", "steam_app_2357570"
WM_PROTOCOLS(ATOM): protocols  WM_DELETE_WINDOW, _NET_WM_PING
_WINE_ALLOW_FLIP(CARDINAL) = 0
STEAM_GAME(CARDINAL) = 2357570
"""


group_name = "Gaming"

game_matches=[
    Match(wm_class=re.compile("steam", re.IGNORECASE))
]

game_group = Group(name=group_name, screen_affinity=1, matches=game_matches)


