# Lucid desktop shell (https://github.com/Sn3akyy1/lucid) on Hyprland.
# The shell is vendored under ./shell (minus its wallpaper pack) so no
# fetching is needed on new machines. Enabling adds a Hyprland session to
# the display manager alongside qtile; it does not replace qtile.
#
# Options (system.lucid.*):
#   enable  bool                  default false
#   theme   str                   default "matugen" — written to
#           ~/.cache/current_theme on every rebuild (the shell watches the
#           file and live-reloads). Bundled themes: matugen (generated from
#           the current wallpaper), catppuccin-mocha, gruvbox, nightfox,
#           nord, pywal, tokyo-night. Custom themes: drop
#           <name>/quickshell.json into ~/.config/lucid/themes/ and set
#           theme = "<name>".
#   mode    enum [dark light]     default "dark"
#
# Layout installed into the user session:
#   ~/.config/quickshell  read-only link to the vendored shell
#   ~/.config/hypr        vendored hyprland.lua + modules (requires Hyprland
#                         0.55+ for the Lua config — pkgs-unstable provides it)
#   ~/.config/lucid       scripts, palettes and state (seeded once, then
#                         writable; the shell edits its own settings here)
#   ~/.config/matugen     palette templates (quickshell, kitty, gtk3, gtk4)
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  globals,
  ...
}:
let
  cfg = config.system.lucid;
  shellSrc = ./shell;
  # Seed prefs with the wallpaper picker pointed at the vendored wallpapers.
  prefsSeeded = pkgs.writeText "lucid-prefs.json" (
    builtins.toJSON (
      (builtins.fromJSON (builtins.readFile (shellSrc + "/defaults/prefs.json")))
      // { wallpaperFolder = toString ../grub/wallpapers; }
    )
  );
in
{
  options.system.lucid = {
    enable = lib.mkEnableOption "Hyprland session with the Lucid desktop shell";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "matugen";
      description = ''
        Lucid theme, written to ~/.cache/current_theme on activation (the
        shell live-reloads when it changes). Bundled: matugen (from the
        wallpaper), catppuccin-mocha, gruvbox, nightfox, nord, pywal,
        tokyo-night. Custom: drop <name>/quickshell.json into
        ~/.config/lucid/themes/ and set theme = "<name>".
      '';
    };
    mode = lib.mkOption {
      type = lib.types.enum [
        "dark"
        "light"
      ];
      default = "dark";
      description = "Light or dark variant of the selected theme.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      # Lucid's hyprland.lua config requires Hyprland 0.55+
      package = pkgs-unstable.hyprland;
      portalPackage = pkgs-unstable.xdg-desktop-portal-hyprland;
    };

    environment.systemPackages =
      (with pkgs; [
        matugen
        jq
        imagemagick
        brightnessctl
        hypridle
        hyprsunset
        grim
        wf-recorder
        ffmpeg
        wl-clipboard
        wtype
        cliphist
        cava
        songrec
        libnotify
        fastfetch
        playerctl
        wireplumber # wpctl, used by the keybinds
        kitty
        nautilus
        gnome-calculator
        python3
      ])
      ++ [
        pkgs-unstable.quickshell
        pkgs-unstable.awww # not in nixos-25.11
      ];

    fonts.packages = [
      (pkgs.runCommand "lucid-google-sans-flex" { } ''
        mkdir -p $out/share/fonts/truetype
        cp ${shellSrc}/assets/fonts/GoogleSansFlex.ttf $out/share/fonts/truetype/
      '')
    ];

    home-manager.users.${globals.user} =
      { lib, ... }:
      {
        xdg.configFile."quickshell".source = shellSrc;

        home.activation.lucidSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          seed() {
            # copy from the store only when missing, and always writable
            if [ ! -e "$2" ]; then
              cp -r --no-preserve=mode "$1" "$2"
              chmod -R u+w "$2"
            fi
          }

          lucidDir="$HOME/.config/lucid"
          mkdir -p "$lucidDir" "$HOME/.cache/quickshell" "$HOME/.config/cava" "$HOME/.config/matugen"

          # theme scripts + bundled palettes (support/lucid/*)
          for item in ${shellSrc}/support/lucid/*; do
            seed "$item" "$lucidDir/$(basename "$item")"
          done

          # state files (pinned apps, reminders, ...) — seeded once, then
          # owned by the shell; prefs is seeded with the wallpaper picker
          # pointed at the vendored wallpapers
          seed ${prefsSeeded} "$lucidDir/prefs.json"
          for f in ${shellSrc}/defaults/*.json; do
            seed "$f" "$lucidDir/$(basename "$f")"
          done

          seed ${shellSrc}/support/hypr/keybinds.json "$lucidDir/keybinds.json"
          seed ${shellSrc}/support/cava/quickshell.conf "$HOME/.config/cava/quickshell.conf"

          # hyprland config is fully managed: refreshed on every activation
          hyprDir="$HOME/.config/hypr"
          rm -rf "$hyprDir"
          cp -r --no-preserve=mode ${shellSrc}/support/hypr "$hyprDir"
          chmod -R u+w "$hyprDir"
          mkdir -p "$hyprDir/scripts/wallpaper"
          cp --no-preserve=mode ${shellSrc}/support/wallpaper/set-wallpaper.sh "$hyprDir/scripts/wallpaper/"

          # matugen: templates + a minimal config (shell, kitty, gtk only)
          for t in ${shellSrc}/support/matugen/templates/*; do
            seed "$t" "$HOME/.config/matugen/templates/$(basename "$t")"
          done
          seed ${pkgs.writeText "matugen-config.toml" ''
            [config]

            [templates.quickshell]
            input_path = "~/.config/matugen/templates/quickshell-colors.json"
            output_path = "~/.cache/quickshell/matugen.json"

            [templates.kitty]
            input_path = "~/.config/matugen/templates/kitty.conf"
            output_path = "~/.config/kitty/matugen-colors.conf"
            post_hook = "killall -SIGUSR1 kitty 2>/dev/null || true"

            [templates.gtk3]
            input_path = "~/.config/matugen/templates/gtk-colors.css"
            output_path = "~/.config/gtk-3.0/colors.css"

            [templates.gtk4]
            input_path = "~/.config/matugen/templates/gtk-colors.css"
            output_path = "~/.config/gtk-4.0/colors.css"
          ''} "$HOME/.config/matugen/config.toml"

          # theme selection — declarative: rebuild wins over runtime changes.
          # the shell watches both files and reloads live
          printf '%s\n' '${cfg.theme}' > "$HOME/.cache/current_theme"
          printf '%s\n' '${cfg.mode}' > "$HOME/.cache/current_mode"
        '';
      };
  };
}
