{config, ...}:
{
  imports = [
    ./zsh_module.nix
    ./tiling_manager.nix
  ];

  config.system.zsh.enable = true;
  config.system.qtile_mod = true;
}