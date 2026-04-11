{pkgs, ...}:
{
    imports = [
        ./garbage_collect.nix
        ./sound.nix
        ./boot_settings.nix
    ];

    environment.systemPackages = with pkgs; [
      btop
      git
      gh
      vesktop
    ];
      
    #https://www.reddit.com/r/NixOS/comments/185f0x4/how_to_mount_a_usb_drive/
    # Enable auto-mouning usbdrives
    services.devmon.enable = true;
    services.gvfs.enable = true; 
    services.udisks2.enable = true;

    # Network
    programs.nm-applet.enable = true;
    networking.networkmanager = {
      enable = true;
    };

    # The nix-ld tool allows unpatched binaries (like those from pip, npm, or pre-compiled games) 
    # to find required libraries automatically.
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
    ];



    # Enables runnign appimage using ./
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    # TODO: Not sure what this does
    xdg = {
      portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };
}
