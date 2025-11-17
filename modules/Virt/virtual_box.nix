{lib, config, pkgs, user, ...}:
with lib;
let 
  cfg = config.vm;
in 
{
  options = {
    vm = {
      enable = mkEnableOption "Enable virtualisation module";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      distrobox
    ];

    users.users.${user} = {
        extraGroups = [ "libvirtd" ];
    };

    # virtualisation.libvirtd = {
    #   enable = true;
    #   qemu = {
    #     package = pkgs.qemu_kvm;
    #     runAsRoot = true;
    #     swtpm.enable = true;
    #   };
    # };

    # programs.virt-manager = {
    #   enable = true;
    # };

  };
}
