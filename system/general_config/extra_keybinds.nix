{
  config,
  lib,
  pkgs,
  globals,
  nixosConfig,
  ...
}:
{
  options.extra_keybinds = {
    enable = lib.mkEnableOption "enable";
  };

  config = lib.mkIf config.extra_keybinds.enable (
    {
      # environment.systemPackages = [
      #   # pkgs.xhost
      # ];

      /* Run a single one-shot service that allows root's services to access user's X session */
      # https://github.com/xremap/nix-flake/blob/master/docs/HOWTO.md#systemwide-example-with-x-feature-for-application-specific-remaps
      # basically needed for application specific keybind
      # !! Does not work at all 
      # systemd.user.services.set-xhost = {
      #   description = "Run a one-shot command upon user login";
      #   path = [ pkgs.xhost ];
      #   wantedBy = [ "default.target" ];
      #   script = "xhost +SI:localuser:${globals.user}";
      #   environment.DISPLAY = ":0.0"; # NOTE: This is hardcoded for this flake
      # };


      services.xremap = {
        # withX11 = true;
        # debug = true;
        enable = true;
        # Modmap for single key rebinds
        # config.modmap = [{
        #   name = "Global";
        #   remap = { "CapsLock" = "Esc"; };
        # }];

        # Keymap for key combo rebinds
        # config.keymap = [
        #     {
        #       name = "Map ctrl-n to down key";
        #       remap = { "C-n" = "Down"; };
        #       # application.only = [ "firefox" ];
        #     }
        #     {
        #       name = "Map ctrl-p to up key";
        #       remap = { "C-p" = "Up"; };
        #       # application.only = [ "firefox" ];
        #     }
        # ];
      };
    } 
  );
}
