
    # "primaryLight": "#a22a32",
    # "primaryDark": "#1e272a",
    # "secondaryLight": "#24e189",
    # "secondaryDark": "",
    # "neutral" : "#312730",
    # "link": "https://coolors.co/1e272a-a22a32-24e189-4b2327-312730"
{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.system.qtile_mod;
  # Palettes vendored from Lucid (https://github.com/Sn3akyy1/lucid),
  # Material You colour roles mapped onto the qtile theme slots.
  paletteNames = [
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
