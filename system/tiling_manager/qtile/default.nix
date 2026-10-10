# qtile window manager module.
#
# Options (system.qtile_mod.*):
#   enable         bool                    default false  — install qtile + picom + rofi
#   palette        enum                    default "custom"
#                  custom | evangelion | catppuccin-mocha | gruvbox |
#                  nightfox | nord | pywal | tokyo-night
#                  "custom" uses the theme.* values below; a named value loads
#                  ../../../theme/palettes/<name>.json (Material You roles from Lucid,
#                  https://github.com/Sn3akyy1/lucid) mapped onto the theme slots.
#   terminal       str                     default "kitty" — spawned by keybinds
#   monitors_list  enum [1 2]              default 2      — bars/widgets layout
#   background     path                                 — wallpaper image
#   theme.*        str (hex colour)                     — primaryLight, primaryDark,
#                  secondaryLight, secondaryDark, neutral; any value set here
#                  overrides the selected palette
#
# Colours are written to /etc/xdg/qtile/config.json, the wallpaper to
# /etc/xdg/qtile/background; config.py/widgets.py read them at runtime.
# The active palette also generates a matching rofi theme
# (~/.config/rofi/qtile-palette.rasi).
{
  pkgs,
  lib,
  config,
  globals,
  ...
}:
with lib;
let
  cfg = config.system.qtile_mod;
  # Palette names must have a matching ../../../theme/palettes/<name>.json with the
  # Material You roles: primary, secondary, surface, surface_container_high,
  # surface_variant. Lucid palettes vendored from https://github.com/Sn3akyy1/lucid;
  # "evangelion" is the original custom theme (https://coolors.co/1e272a-a22a32-24e189-4b2327-312730).
  paletteNames = [
    "evangelion"
    "celltower"
    "rumda"
    "rumda-light"
    "caelestia"
    "ariealerr"
    "catppuccin-mocha"
    "gruvbox"
    "nightfox"
    "nord"
    "pywal"
    "tokyo-night"
  ];
  paletteColors =
    name:
    let
      p = builtins.fromJSON (builtins.readFile (../../../theme/palettes + "/${name}.json"));
    in
    {
      primaryLight = p.primary;
      primaryDark = p.surface;
      secondaryLight = p.secondary;
      secondaryDark = p.surface_container_high;
      neutral = p.surface_variant;
    };
in
{
  options.system.qtile_mod = {
    enable = mkEnableOption "Enable qtile setup";
    palette = mkOption {
      type = types.enum ([ "custom" ] ++ paletteNames);
      default = "custom";
      description = ''
        Colour palette for the bar/widgets. "custom" uses the theme.* values
        below; anything else loads a vendored Lucid palette from ../../../theme/palettes
        (individual theme.* settings still override the palette).
      '';
    };
    monitors_list = mkOption {
      type = types.enum [1 2];
      default = 2;
    };
    background = mkOption {
      type = types.path;
      description = "Background path";
    };
    terminal = mkOption {
      type = types.str;
      default = "kitty";
      description = "Terminal emulator command spawned by the keybinds.";
    };
    bar_style = mkOption {
      type = types.enum [
        "default"
        "caelestia"
        "rumda"
      ];
      default = "default";
      description = ''
        Bar layout, styled after the linked dotfiles themes:
        "default" (current layout), "caelestia" (workspaces + media chip,
        system cluster right), "rumda" (media beside workspaces, spaced
        modules, tray at the far right).
      '';
    };
    theme.primaryLight = mkOption {
      type = types.str;
      description = ''RGB values of primaryLight. Ex: #a22a32'';
      default = "#a22a32";
    };
    theme.primaryDark = mkOption {
      type = types.str;
      description = ''RGB values of primaryDark. Ex: #1e272a'';
      default = "#1e272a";
    };
    theme.secondaryLight= mkOption {
      type = types.str;
      description = ''RGB values of primaryLight. Ex: #1e272a'';
      default = "#24e189";
    };
    theme.secondaryDark= mkOption {
      type = types.str;
      description = ''RGB values of . secondaryDark Ex: #1e272a'';
      default = "#4b2327";
    };
    theme.neutral = mkOption {
      type = types.str;
      description = ''RGB values of neutral . Ex: #1e272a'';
      default = "#312730";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable && cfg.palette != "custom") {
      system.qtile_mod.theme = mapAttrs (_: mkDefault) (paletteColors cfg.palette);
    })

    (mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.rofi
      pkgs.picom
      # pkgs.kitty
      # pkgs.polybar
    ];
    # Needed for transparent bar
    services.picom = {
      enable = true;
    };

    services.xserver.windowManager.qtile = {
      enable = true;
      configFile = ./config.py;
      extraPackages = python3Packages: with python3Packages; [
        qtile-extras
        pulsectl-asyncio
        dbus-next # for the Mpris2 music widget
      ];
    };

    environment = {
      etc."xdg/qtile/widgets.py" = {
        source = ./widgets.py;
      };
      etc."xdg/qtile/constants.py" = {
        source = ./constants.py;
      };
      etc."xdg/qtile/background" = {
        source = config.system.qtile_mod.background;
      };
      etc."xdg/qtile/config.json" = {
        text = builtins.toJSON {
            monitors_list = config.system.qtile_mod.monitors_list;
            terminal = config.system.qtile_mod.terminal;
            bar_style = config.system.qtile_mod.bar_style;
            primaryLight = config.system.qtile_mod.theme.primaryLight;
            primaryDark = config.system.qtile_mod.theme.primaryDark;
            secondaryLight = config.system.qtile_mod.theme.secondaryLight;
            secondaryDark = config.system.qtile_mod.theme.secondaryDark;
            neutral = config.system.qtile_mod.theme.neutral;
        };
      };
    };

    # rofi follows the active palette
    home-manager.users.${globals.user} = {
      xdg.configFile."rofi/config.rasi".text = ''
        @theme "qtile-palette"
      '';
      xdg.configFile."rofi/qtile-palette.rasi".text = with cfg.theme; ''
        * {
            background-color: transparent;
            text-color: ${secondaryLight};
        }
        window {
            background-color: ${primaryDark};
            border: 2px;
            border-color: ${primaryLight};
            border-radius: 12px;
            width: 640px;
            padding: 16px;
        }
        inputbar {
            background-color: ${secondaryDark};
            border-radius: 8px;
            padding: 8px 12px;
            spacing: 8px;
            children: [ prompt, entry ];
        }
        prompt { text-color: ${primaryLight}; }
        entry { placeholder-color: ${neutral}; }
        listview {
            lines: 8;
            spacing: 4px;
            margin: 12px 0 0 0;
        }
        element {
            padding: 8px 12px;
            border-radius: 8px;
        }
        element selected {
            background-color: ${primaryLight};
            text-color: ${primaryDark};
        }
        element-icon { size: 24px; }
      '';
    };
  })
  ];
}
