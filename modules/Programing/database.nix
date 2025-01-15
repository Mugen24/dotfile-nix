{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    pgadmin4
  ];
}

