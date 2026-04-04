{pkgs, config, lib, ...}:
{
    options.tmux = {
        enable = lib.mkEnableOption "Enable";
    };
    config = lib.mkIf config.tmux.enable {
        home.packages = [
            pkgs.nerd-fonts.symbols-only
            pkgs.fzf
            pkgs.pstree
            pkgs.bat
        ];
        programs.tmux = {
            enable = true;
            shell = "${pkgs.zsh}/bin/zsh";
            keyMode = "vi";
            plugins = with pkgs.tmuxPlugins; [
                tokyo-night-tmux
                resurrect
                sensible
                pain-control
                extrakto
                better-mouse-mode
                tmux-sessionx
                copycat
                tmux-fzf
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

                set -g @plugin 'tmux-plugins/tmux-resurrect'
                set -g @resurrect-capture-pane-contents 'on' 

                set -g @plugin 'sainnhe/tmux-fzf'

                set -g @plugin "janoamaral/tokyo-night-tmux"
                set -g @tokyo-night-tmux_theme storm    # storm | day | default to 'night'
                set -g @tokyo-night-tmux_transparent 1  # 1 or 0

                # bind r source-file /etc/tmux.conf; display "Config reloaded!"
                # bind f run-shell -b ${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/main.sh

                set -g @plugin 'nhdaly/tmux-better-mouse-mode'
                set -g mouse on
                set -g @scroll-without-changing-pane "on"

                set -g @plugin 'omerxx/tmux-sessionx'
                unbind f
                set -g @sessionx-bind 'f'
                set -g @sessionx-window-mode 'on'
                set -g @sessionx-filter-current 'false'

                bind S command-prompt -p "New Session:" "new-session -A -s '%%'"
                bind K confirm kill-session

            '';
        };
    };
}
