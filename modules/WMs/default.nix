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
      extraPackages = python3Packages: with python3Packages; [
        qtile-extras
        pulsectl-asyncio
      ];
    };
    environment = {
      etc."xdg/qtile/widgets.py" = {
        source = ./qtile/widgets.py;
      };
      etc."xdg/qtile/constants.py" = {
        source = ./qtile/constants.py;
      };
    };
  };
}
