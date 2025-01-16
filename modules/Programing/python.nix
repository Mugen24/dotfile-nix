{ config, pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      python3
      python311Packages.pip
    ];
  };
}


