{lib, config, pkgs, user, ...}:
with lib;
{
  options = {
    tmux = {
      enable = mkEnableOption "Enable virtualisation module";
    };
  };

  config = mkIf config.tmux.enable {
    environment.systemPackages = with pkgs; [
       
    ];
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        tokyo-night-tmux
        resurrect
        sensible
      ];
      extraConfig = ''
        set -g @resurrect-capture-pane-contents 'on' 
        set -g @plugin 'tmux-plugins/tmux-resurrect'

        set -g @plugin "janoamaral/tokyo-night-tmux"
        set -g @tokyo-night-tmux_theme storm    # storm | day | default to 'night'
        set -g @tokyo-night-tmux_transparent 1  # 1 or 0
      '';
    };
  };
}
