{pkgs, lib, config, user, ...}:
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
      users.users.${user} = {
        extraGroups = [ "gamemode" ];
      };
      programs.java.enable = true; 

      environment.systemPackages = with pkgs; [
        # Possible gaming server
        #gamevault
        #gammeyfin
        #Gaseous Server
      ];

      programs.gamemode.enable = true;
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        # package vs extraPackages
        package = pkgs.steam.override {
          extraPkgs = (pkgs: with pkgs; [
            gamemode
            # additional packages...
            # e.g. some games require python3
          ]);
        };

        extraPackages = with pkgs; [
          gamescope
          mangohud
          gamemode
        ];
      };  

      programs.steam.gamescopeSession.enable = true;

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdg.portal.config.common.default = "gtk";
      services.flatpak.enable = true;
      systemd.services.flatpak-repo = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        '';
      };

      # Commands that needs to be manually run for flatpak/flathub to work properly
      # https://nixos.org/manual/nixos/stable/index.html#module-services-flatpak
      # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      # flatpak update
    };
  }
