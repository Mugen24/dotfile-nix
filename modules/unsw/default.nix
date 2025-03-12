{pkgs, lib, config, user, ...}:
with lib;
let 
  cfg = config.unsw;
in
{
  options.unsw = {
    enable = mkEnableOption "UNSW config";
  };


  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sshfs
    ];
    home-manager.users.${user} = {
      programs.zsh = {
	shellGlobalAliases = {
	  vl = "ssh z5363945@login.cse.unsw.edu.au";
	  vm = "sshfs z5363945@login.cse.unsw.edu.au:/import/cage/5/z5363945/Desktop ~/Vlab_mount/";
	};
      };

    };
  };
}
