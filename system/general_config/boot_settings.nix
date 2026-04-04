{pkgs, ...}:
{
    boot.loader.grub.configurationLimit = 10;
    boot.loader.systemd-boot.configurationLimit = 10;

    # Fixes suspend issues 
    # https://nixos.wiki/wiki/Power_Management
    # Disallow all pcie ability to wake PC 
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
    '';
  
    # Fixes suspend issues for gigabyte mobo
    # https://wiki.archlinux.org/title/Power_management/Wakeup_triggers#/sys/devices/
    boot.kernelParams = [
      ''acpi_osi="!Windows 2015"''
    ];

    # can't upgrade system without this
    # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
    services.logrotate.checkConfig = false;

    # 
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.kernelModules = [ 
    ];
    # boot.kernelParams = [
    # ];
}
