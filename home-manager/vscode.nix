{
  globals,
  config,
  lib,
  pkgs,
  ...
}:
{
  options.vscode = {
    enable = lib.mkEnableOption "Enable";
  };

  config = lib.mkIf config.vscode.enable (
    lib.mkMerge [
      {
        home.packages = [
          pkgs.nil
        ];

        programs.vscode = {
          enable = true;
          # mutableExtensionsDir = true;
          mutableExtensionsDir = false;
          extensions = with pkgs.vscode-extensions; [
            dracula-theme.theme-dracula
            vscodevim.vim
            jnoortheen.nix-ide
            continue.continue
          ];
          keybindings = [
            {
              "key" = "ctrl+n";
              "command" = "workbench.action.quickOpenSelectNext";
              "when" = "inQuickOpen";
            }
            {
              "key" = "ctrl+p";
              "command" = "workbench.action.quickOpenSelectPrevious";
              "when" = "inQuickOpen";
            }
          ];
          userSettings = {
            "continue.enableConsole" = true;
            "workbench.colorTheme" = "Dracula Theme";
            "vim.insertModeKeyBindings" = [
              {
                "before" = [
                  "j"
                  "j"
                ];
                "after" = [ "<esc>" ];
              }
            ];
            "vim.leader" = "<space>";
            "vim.normalModeKeyBindingsNonRecursive" = [
                {
                    "before" = ["<leader>" "f" "f"];
                    "commands" = ["workbench.action.quickOpen"];
                }
            ];
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nil";
            "nix.serverSettings" = {
              "nil" = {
                "formatting" = {
                  "command" = [ "nixfmt" ];
                };
              };
            };
          };
        };
      }
    ]
  );
}
