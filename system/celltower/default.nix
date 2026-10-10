# Cell Tower desktop look (X11/qtile side).
# GTK theme + wallpaper vendored from https://gitlab.com/dejan-z/xfce-stuff
# (Cell Tower) under ./theme — no XFCE session is installed, only the
# standalone apps (xfce4-terminal, thunar) and the theme files.
#
# Options (system.celltower.*):
#   enable  bool  default false — applies the Cell Tower look:
#           qtile palette "celltower" + wallpaper + xfce4-terminal
#           (mkOverride 90: wins over explicit qtile_mod settings while
#           enabled, your own settings return when disabled), GTK 2/3 theme,
#           GohuFont 11 Nerd Font, thunar + ranger
#   iconTheme.name / iconTheme.package  default null — icon pack wiring,
#           applied only when both are set
{
  config,
  lib,
  pkgs,
  globals,
  ...
}:
let
  cfg = config.system.celltower;
  gtkTheme = pkgs.runCommand "cell-tower-gtk-theme" { } ''
    mkdir -p "$out/share/themes/Cell Tower"
    cp -r ${./theme}/* "$out/share/themes/Cell Tower/"
  '';
  terminalrc = pkgs.writeText "terminalrc" ''
    [Configuration]
    FontName=GohuFont 11 Nerd Font 11
  '';
in
{
  options.system.celltower = {
    enable = lib.mkEnableOption "Cell Tower desktop look (qtile/X11)";
    iconTheme = {
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Icon theme name (applied only when package is also set).";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        description = "Package providing the icon theme under share/icons.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # qtile look — mkOverride 90 so enabling this module wins over the
    # explicit qtile_mod settings in the root default.nix
    system.qtile_mod = {
      palette = lib.mkOverride 90 "celltower";
      background = lib.mkOverride 90 ./theme/a-cell-tower.png;
      terminal = lib.mkOverride 90 "xfce4-terminal";
    };

    environment.systemPackages = [
      pkgs.xfce.xfce4-terminal
      pkgs.xfce.thunar
      pkgs.ranger
    ];

    fonts.packages = [ pkgs.nerd-fonts.gohufont ];

    home-manager.users.${globals.user} =
      { lib, ... }:
      {
        gtk = {
          enable = true;
          theme = {
            name = "Cell Tower";
            package = gtkTheme;
          };
          font = {
            name = "GohuFont 11 Nerd Font";
            size = 11;
          };
          iconTheme = lib.mkIf (cfg.iconTheme.name != null && cfg.iconTheme.package != null) {
            name = cfg.iconTheme.name;
            package = cfg.iconTheme.package;
          };
        };

        # xfce4-terminal rewrites this file itself, so seed it writable once
        home.activation.celltowerTerminal = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          termDir="$HOME/.config/xfce4/terminal"
          if [ ! -e "$termDir/terminalrc" ]; then
            mkdir -p "$termDir"
            cp --no-preserve=mode ${terminalrc} "$termDir/terminalrc"
          fi
        '';
      };
  };
}
