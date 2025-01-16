{ config, pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      pgadmin4
    ];
  };
}

