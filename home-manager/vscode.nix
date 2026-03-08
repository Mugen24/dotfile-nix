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
          mutableExtensionsDir = true;
          extensions = with pkgs.vscode-extensions; [
            dracula-theme.theme-dracula
            vscodevim.vim
            jnoortheen.nix-ide
          ];
          userSettings = {
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
