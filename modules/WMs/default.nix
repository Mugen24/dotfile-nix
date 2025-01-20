{pkgs, lib, ...}:
with lib;
let 
  cfg = config.qtile_mod;
in
{
  options.qtile_mod = {
    enable = mkEnableOption "Enable WMs setup";
    monitors = mkOption {
      type = types.enum [1 2];
      default = 2;
    };
    theme = mkOption {
      type = types.enum ["cyberpunk"];
      default = "cyberpunk";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.qtile = {
      enable = true;
      configFile = ./config.py;
    };
    environment.variables = {
      QTILE_THEME = cfg.theme;
      QTILE_MONITOR_LIST = cfg.monitors;
    };

  };
}
