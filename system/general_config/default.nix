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
