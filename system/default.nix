{config, ...}:
{
  imports = [
    ./zsh_module.nix
  ];

  config.system.zsh.enable = true;
}