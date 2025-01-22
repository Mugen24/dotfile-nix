{lib, pkgs, config, ...}: {
  imports = [
    ./modules/WMs/default.nix
    ./theme_customisation.nix
  ];
  
  qtile_mod = {
    enable = true;
  };
  theme = {
    enable = true;
    monitors_list = 2;
  };
  environment.variables = {
    USER_ROOT = "/etc/nixos";
  };
}
