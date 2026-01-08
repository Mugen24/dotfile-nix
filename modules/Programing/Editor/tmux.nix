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
      fzf
      xclip
    ];


    programs.tmux = {
      enable = true;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        tokyo-night-tmux
        resurrect
        sensible
        pain-control
        tmux-fzf
        extrakto
      ];
      extraConfig = ''
        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix

        set-option -g status-interval 5
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{pane_title} #{pane_current_path} #{pane_current_command}'


        set -g @plugin 'laktak/extrakto'

        set-option -g pane-active-border-style "fg=red"

        set -g @resurrect-capture-pane-contents 'on' 
        set -g @plugin 'tmux-plugins/tmux-resurrect'
        set -g @plugin 'sainnhe/tmux-fzf'

        set -g @plugin "janoamaral/tokyo-night-tmux"
        set -g @tokyo-night-tmux_theme storm    # storm | day | default to 'night'
        set -g @tokyo-night-tmux_transparent 1  # 1 or 0

        bind r source-file /etc/tmux.conf; display "Config reloaded!"
        bind f run-shell -b ${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/main.sh
      '';
    };
  };
}
