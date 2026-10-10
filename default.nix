{config, ...}:
{
  config.system.zsh.enable = true;
  config.system.qtile_mod = {
    enable = true;
    monitors_list = 2;
    background = ./system/tiling_manager/wallpapers/neon_shallows.png;
    # To match the GRUB theme instead: config.system.grub_theme.wallpaper
    # Palette: evangelion | catppuccin-mocha | gruvbox | nightfox | nord | pywal | tokyo-night
    # ("custom" ignores palettes and uses an explicit theme = { ... } block here)
    palette = "gruvbox";
  };

  config.system.gpus = {
    amd.enable = true;
  };
  config.gaming = {
    enable = true;
    enableVR = true;
  };
  config.extra_keybinds.enable = true;

  config.system.grub_theme = {
    enable = true;
    theme = "soryu";
    resolution = "1440p";
  };
}
