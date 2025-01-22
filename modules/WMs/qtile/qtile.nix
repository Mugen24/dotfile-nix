{pkgs, ...}:
{
  services.xserver.windowManager.qtile = {
    enable = true;
    configFile = ./config.py;
  };
}
