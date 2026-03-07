{ config, nixpkgs, globals, ... }:
{
    imports = [
        ./zsh_module.nix
        ./tmux_module.nix
        ./nvim
    ];

    config.zsh.enable = true;
    config.tmux.enable = true;
    config.nvim.enable = true;
}

