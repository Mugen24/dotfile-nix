{ config, pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      tigervnc
      teams-for-linux    
      docker_28
      docker-compose
      dash

      sqlitebrowser
    ];
  };
}

