{pkgs, lib, config, ...}:
with lib;
let 
  cfg = config.unsw;
in
{
  options.unsw = {
    enable = mkEnableOption "UNSW config";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.zsh = {
	shellGlobalAliases = {
	  vlab = "ssh z1234567@login.cse.unsw.edu.au";
	};
      };

    };
  };
}
