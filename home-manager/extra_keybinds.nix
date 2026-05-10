{
  config,
  lib,
  pkgs,
  globals,
  nixosConfig,
  ...
}:
{
  options.extra-keybinds = {
    enable = lib.mkEnableOption "enable";
  };

  config = lib.mkIf config.extra-keybinds.enable (
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
