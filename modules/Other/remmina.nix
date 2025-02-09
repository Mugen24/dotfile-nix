{pkgs, config, ...}: 
{
  environment.systemPackages = with pkgs; [
    remmina
  ];
  networking.firewall = {
    allowedTCPPorts = [ 3389 3390 ];
  };

}
