{config, ...}:
{
  imports = [
    ./zsh_module.nix
    ./tiling_manager
    ./gpus
    ./LLM
    ./Gaming
    ../theme/grub
    ../theme/lucid
    ../theme/celltower
  ];

  # config.system.zsh.enable = true;
  # config.system.qtile_mod = {
  #   enable = true;
  #   monitors_list = 2;
  #   background = ./tiling_manager/wallpapers/neon_shallows.png;
  #   theme = {
  #     primaryLight = "#a22a32";
  #     primaryDark = "#1e272a";
  #     secondaryLight = "#24e189";
  #     secondaryDark = "#4b2327";
  #     neutral = "#312730";
  #   };
  # };
}
