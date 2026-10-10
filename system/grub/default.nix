# GRUB with vendored Evangelion themes (https://github.com/Aleph1-9012/Evangelion)
# Theme files live in ./themes so no fetching is needed on new machines.
# Enabling this module switches the bootloader from systemd-boot to GRUB.
{
  config,
  lib,
  ...
}:
let
  cfg = config.system.grub_theme;
  availableThemes = [
    "ayanami"
    "eva01"
    "eva02"
    "penpen"
    "ramiel"
    "seele"
    "soryu"
    "wunder"
  ];
  resolutions = {
    "720p" = "1280x720";
    "1080p" = "1920x1080";
    "1440p" = "2560x1440";
  };
in
{
  options.system.grub_theme = {
    enable = lib.mkEnableOption "GRUB boot menu with Evangelion theme";
    theme = lib.mkOption {
      type = lib.types.enum availableThemes;
      default = "soryu";
      description = "Which vendored theme to use. See ./themes for the list.";
    };
    resolution = lib.mkOption {
      type = lib.types.enum (builtins.attrNames resolutions);
      default = "1440p";
      description = "Theme profile matching your monitor resolution.";
    };
    wallpaper = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      description = "4K wallpaper matching the selected theme, from ./wallpapers. Reference this from other modules (e.g. qtile background) to keep the desktop in sync with the boot theme.";
    };
  };

  config = lib.mkMerge [
    {
      system.grub_theme.wallpaper = ./wallpapers + "/${cfg.theme}.png";
    }

    (lib.mkIf cfg.enable {
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        configurationLimit = 10;
        gfxmodeEfi = resolutions.${cfg.resolution};
        theme = ./themes + "/${cfg.theme}/${cfg.resolution}";
      };
    })
  ];
}
