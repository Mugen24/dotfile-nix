{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    teams-for-linux    
    docker_27
    docker-compose
  ];
}

