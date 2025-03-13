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

    fonts.packages = with pkgs; [
      emacsPackages.all-the-icons-nerd-fonts
      # nerd-fonts.symbols-only
      # nerd-fonts.jetbrains-mono
      # nerd-fonts.code-new-roman
      # nerd-fonts.sauce-code-pro
      
      # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      # nerdfonts
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };
}
