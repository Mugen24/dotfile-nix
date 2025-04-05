{ config, pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      tigervnc
      teams-for-linux    
      docker_27
      docker-compose
      dash

      sqlitebrowser
    ];
  };
}

