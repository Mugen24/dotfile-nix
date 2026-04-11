{pkgs, lib, config, ...}: {
  options.system.gpus.amd = {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf config.system.gpus.amd.enable {
      # Enable OpenGL
    
    environment.systemPackages = with pkgs; [
      amdgpu_top
    ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
      enable32Bit = true;

      # extraPackages32 = with pkgs; [ 

      # ];
    };
    # Configure keymap in X11
    services.xserver = {
      enable = true;  
      videoDrivers = ["amdgpu"];
      xkb = {
        layout = "au";
      };
      extraConfig = ''
      # https://wiki.archlinux.org/title/Display_Power_Management_Signaling
      # Disable monitor power saving
      Section "Extensions"
        Option "DPMS" "false"
      EndSection

      Section "ServerFlags"
        Option "BlankTime" "0"
      EndSection
      '';
    };

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
