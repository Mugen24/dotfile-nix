# qtile window manager module.
#
# Options (system.qtile_mod.*):
#   enable         bool                    default false  — install qtile + picom + rofi
#   palette        enum                    default "custom"
#                  custom | evangelion | catppuccin-mocha | gruvbox |
#                  nightfox | nord | pywal | tokyo-night
#                  "custom" uses the theme.* values below; a named value loads
#                  ./palettes/<name>.json (Material You roles from Lucid,
#                  https://github.com/Sn3akyy1/lucid) mapped onto the theme slots.
#   monitors_list  enum [1 2]              default 2      — bars/widgets layout
#   background     path                                 — wallpaper image
#   theme.*        str (hex colour)                     — primaryLight, primaryDark,
#                  secondaryLight, secondaryDark, neutral; any value set here
#                  overrides the selected palette
#
# Colours are written to /etc/xdg/qtile/config.json, the wallpaper to
# /etc/xdg/qtile/background; config.py/widgets.py read them at runtime.
{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.system.qtile_mod;
  # Palette names must have a matching ./palettes/<name>.json with the
  # Material You roles: primary, secondary, surface, surface_container_high,
  # surface_variant. Lucid palettes vendored from https://github.com/Sn3akyy1/lucid;
  # "evangelion" is the original custom theme (https://coolors.co/1e272a-a22a32-24e189-4b2327-312730).
  paletteNames = [
    "evangelion"
    "celltower"
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
      p = builtins.fromJSON (builtins.readFile (./palettes + "/${name}.json"));
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
        below; anything else loads a vendored Lucid palette from ./palettes
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
            primaryLight = config.system.qtile_mod.theme.primaryLight;
            primaryDark = config.system.qtile_mod.theme.primaryDark;
            secondaryLight = config.system.qtile_mod.theme.secondaryLight;
            secondaryDark = config.system.qtile_mod.theme.secondaryDark;
            neutral = config.system.qtile_mod.theme.neutral;
            # link: "https://coolors.co/1e272a-a22a32-24e189-4b2327-312730"
        };
      };
    };
  })
  ];
}
