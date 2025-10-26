{pkgs, lib, config, user, ...}:
with lib;
let 
  cfg = config.gaming;
in
  {
    options = {
      gaming = {
        enable = mkEnableOption "Enable module";
        yuzu = mkEnableOption "Enable yuzu";
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
        # (pkgs.callPackage ./gamescope.nix)
        # bottles
        # lutris

        # wine
        # winetricks
      ];

      programs.gamemode.enable = true;
      programs.gamescope = {
         enable = true;
         capSysNice = true;
      };

      hardware.steam-hardware = {
        enable = true;
      };

      
      # services.monado = {
      #   enable = true;
      #   # defaultRuntime = true; # Register as default OpenXR runtime
      # };

      programs.git = {
        enable = true;
        lfs.enable = true;
      };

      # systemd.user.services.monado.environment = {
      #   STEAMVR_LH_ENABLE = "1";
      #   XRT_COMPOSITOR_COMPUTE = "1";
      # };


      # services.wivrn = {
      #   enable = true;
      #   openFirewall = true;

      #   # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
      #   # will automatically read this and work with WiVRn (Note: This does not currently
      #   # apply for games run in Valve's Proton)
      #     defaultRuntime = true;

      #   # Run WiVRn as a systemd service on startup
      #   autoStart = true;

      #   # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
      #   package = (pkgs.wivrn.override { cudaSupport = true; });

      #   # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
      #   config = {
      #     enable = true;
      #     json = {
      #       # 1.0x foveation scaling
      #       scale = 1.0;
      #       # 100 Mb/s
      #       bitrate = 100000000;
      #       encoders = [
      #         {
      #           encoder = "vaapi";
      #           codec = "h265";
      #           # 1.0 x 1.0 scaling
      #           width = 1.0;
      #           height = 1.0;
      #           offset_x = 0.0;
      #           offset_y = 0.0;
      #         }
      #       ];
      #     };
      #   };
      # };


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
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ]);
          extraLibraries = pkgs: [ pkgs.xorg.libxcb ];
        };
        gamescopeSession.enable = true;

        extraPackages = with pkgs; [
          # gamescope
          mangohud
          gamemode
        ];

      };  


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
