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
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 10;
      gfxmodeEfi = resolutions.${cfg.resolution};
      theme = ./themes + "/${cfg.theme}/${cfg.resolution}";
    };
  };
}
