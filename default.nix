{lib, pkgs, config, ...}: {
  imports = [
    ./modules/WMs
    ./theme_customisation.nix
    ./modules/Gaming
    ./modules/unsw
  ];
  
  qtile_mod = {
    enable = true;
  };
  unsw = {
    enable = true;
  };
  theme = {
    enable = true;
    monitors_list = 2;
  };
  environment.variables = {
    USER_ROOT = "/etc/nixos";
  };

  gaming.enable = true;
}
