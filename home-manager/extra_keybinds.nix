{
  config,
  lib,
  pkgs,
  globals,
  nixosConfig,
  ...
}:
{
  options.extra-keybind = {
    enable = lib.mkEnableOption "enable";
  };

  config = lib.mkIf config.custom-keybind.enable (
    {
      services.xremap = {
        enable = true;
        # Modmap for single key rebinds
        # config.modmap = [{
        #   name = "Global";
        #   remap = { "CapsLock" = "Esc"; };
        # }];

        # Keymap for key combo rebinds
        config.keymap = [{
          name = "Map Super-n to down key";
          remap = { "Super-n" = "Down"; };
        }];
      };
    } 
  );
}
