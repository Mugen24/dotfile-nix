{pkgs, lib, config, globals, ...}:
with lib;
let 
  cfg = config.gaming.enableVR;
in
  {
    options = {
      gaming = {
        enableVR = mkEnableOption "Enable module";
      };

    };

    config = mkIf cfg {
      users.users.${globals.user} = {
        extraGroups = [ "gamemode" ];
      };
      programs.java.enable = true; 

      environment.systemPackages = with pkgs; [
        lutris
        wineWowPackages.stable
        winetricks
        vulkan-tools
      ];

      programs.gamemode.enable = true;
      programs.gamescope = {
         enable = true;
         capSysNice = true;
      };

      hardware.steam-hardware = {
        enable = true;
      };

      
      services.monado = {
        enable = true;
        defaultRuntime = true; # Register as default OpenXR runtime
      };

      programs.alvr = {
        enable = true;
        # package = pkgs.unstable.alvr;
        openFirewall = true;
      };

      boot.kernelPatches = [
        {
          name = "amdgpu-ignore-ctx-privileges";
          patch = pkgs.fetchpatch {
            name = "cap_sys_nice_begone.patch";
            url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
            hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
          };
        }
      ];

      systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
      };


      services.wivrn = {
        enable = true;
        openFirewall = true;


        # Run WiVRn as a systemd service on startup
        autoStart = true;

        # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
        package = (pkgs.wivrn.override { cudaSupport = true; });

        # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
        config = {
          enable = true;
          json = {
            # 1.0x foveation scaling
            scale = 1.0;
            # 100 Mb/s
            bitrate = 100000000;
            encoders = [
              {
                encoder = "vaapi";
                codec = "h265";
                # 1.0 x 1.0 scaling
                width = 1.0;
                height = 1.0;
                offset_x = 0.0;
                offset_y = 0.0;
              }
            ];
          };
        };
      };

      programs.steam = {
        enable = true;
      };  
    };
  }
