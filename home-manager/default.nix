{ config, nixpkgs, globals, ... }:
{
    imports = [
        ./zsh_module.nix
        ./tmux_module.nix
        ./nvim
        ./vscode.nix
    ];

    config.zsh.enable = true;
    config.tmux.enable = true;
    config.nvim.enable = true;
    config.vscode.enable = true;
}

