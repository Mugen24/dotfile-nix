{pkgs, lib, config, ...}:
with lib;
let 
  cfg = config.gaming;
in
  {
    options = {
      gaming = {
        enable = mkEnableOption "Enable module";
      };
    };
    config = mkIf cfg.enable {
      programs.java.enable = true; 
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };  
      programs.steam.gamescopeSession.enable = true;

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdg.portal.config.common.default = "gtk";
      services.flatpak.enable = true;
      # Commands that needs to be manually run for flatpak/flathub to work properly
      # https://nixos.org/manual/nixos/stable/index.html#module-services-flatpak
      # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      # flatpak update
    };
  }
