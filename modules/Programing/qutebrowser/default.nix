{config, pkgs, user, ...}:
{
  environment.systemPackages = with pkgs; [
    qutebrowser
  ];

}


