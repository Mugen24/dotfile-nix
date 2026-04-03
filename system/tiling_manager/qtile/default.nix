
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
{
  options.system.qtile_mod = {
    enable = mkEnableOption "Enable qtile setup";
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

  config = mkIf config.system.qtile_mod.enable {
    environment.systemPackages = [
      pkgs.rofi
      pkgs.kitty
    ];
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
  };
}
