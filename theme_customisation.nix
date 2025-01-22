{pkgs, lib, config, ...}: 
with lib;
let 
  cfg = config.theme;
in
{
  options.theme = {
    enable = mkEnableOption "Device wide customisation";
    customisation = mkOption {
      type = types.enum ["cyberpunk" "shallow"];
      default = "shallow" ;
      description = ''
	Apply a system-wide theme currently will only effect:
	  WM: 
	    qtile
	  Editor:
	    neovim
	  Bar:
      '';
    };
    monitors_list = mkOption {
      type = types.enum [1 2];
      default = 2;
    };
  };

  config = mkIf cfg.enable {
    environment.variables = {
      USER_THEME = cfg.customisation;
      USER_MONITORS_LIST = cfg.monitors_list;
    };
  };
}
