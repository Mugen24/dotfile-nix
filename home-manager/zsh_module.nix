{
  config,
  lib,
  pkgs,
  globals,
  nixosConfig,
  ...
}:
{
  options.zsh = {
    enable = lib.mkEnableOption "enable";
    # standalone = lib.mkOption {
    #   default = "standalone";
    #   description = ''
    #     				standalone | nixos
    #     				- nixos
    #     					Set default shell to zsh
    #     			'';
    # };
  };

  config = lib.mkIf config.zsh.enable (
    lib.mkMerge [
      {
        home.packages = [
          pkgs.eza
        ];

        programs.git = {
          enable = true;
          settings = {
            user.name = globals.gitName;
            user.email = globals.email;
          };
        };

        # z-jump
        programs.zoxide = {
          enable = true;
          enableZshIntegration = true;
        };

        programs.direnv = {
          # enable automatic nix dev shell setup using .envrc
          enable = true;
          nix-direnv.enable = true;
        };

        programs.zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          history = {
            share = true;
          };

          oh-my-zsh = {
            enable = true;
            theme = "awesomepanda";
          };

          plugins = [
            {
              name = "zsh-fzf-tab";
              src = pkgs.zsh-fzf-tab;
              file = "share/fzf-tab/fzf-tab.plugin.zsh";
            }

            {
              name = "zsh-vi-mode";
              src = pkgs.zsh-vi-mode;
              file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
            }
          ];

          initContent = ''
            									ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
            									unsetopt BEEP

            									# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath' # remember to use single quote here!!!
            									zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -l --color=always $realpath' # remember to use single quote here!!!
            								'';
          shellGlobalAliases = {
            ls = "eza -l --color=always --time-style relative";
            hm-build = "home-manager build --flake .";
            hm-switch = "home-manager switch --flake .";
            hm = "hm-build; hm-switch";
          };

          localVariables = {
          };
        };

      }
    ]
  );
}
