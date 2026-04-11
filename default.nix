{config, ...}:
{
  config.system.zsh.enable = true;
  config.system.qtile_mod = {
    enable = true;
    monitors_list = 2;
    background = ./system/tiling_manager/wallpapers/neon_shallows.png;
    theme = {
      primaryLight = "#a22a32";
      primaryDark = "#1e272a";
      secondaryLight = "#24e189";
      secondaryDark = "#4b2327";
      neutral = "#312730";
    };
  };

  config.system.gpus = {
    amd.enable = true;
  };
  config.gaming = {
    enable = true;
  };
}
