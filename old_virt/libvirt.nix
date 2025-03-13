{ pkgs, ... }:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  users.users.mugen.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-viewer
    looking-glass-client
    #virtio-win
    #win-spice
  ];
  programs.virt-manager.enable = true;

#   home-manager.users.mugen = {
#     dconf.settings = {
#       "org/virt-manager/virt-manager/connections" = {
#         autoconnect = [ "qemu:///system" ];
#         uris = [ "qemu:///system" ];
#       };
#     };
#   };
}
