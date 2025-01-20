{lib, pkgs, config, ...}: {
  imports = [
    ./modules/WMs/default.nix
  ];
  
  qtile_mod = {
    enable = true;
  };

}
