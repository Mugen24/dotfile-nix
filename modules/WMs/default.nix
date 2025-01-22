{pkgs, lib, config, ...}:
with lib;
let 
  cfg = config.qtile_mod;
in
{
  options.qtile_mod = {
    enable = mkEnableOption "Enable WMs setup";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.qtile = {
      enable = true;
      configFile = ./qtile/config.py;
    };
  };
}
