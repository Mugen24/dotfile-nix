# dotfile-nix

Declarative Nix configuration that works as a **full NixOS system**, as **standalone home-manager** on any Linux distro, and across **multiple devices** — all from one flake.

## How it works

The repo is built around three ideas:

### 1. One flake, two modes (`flake.nix`)

`flake.nix` exposes two outputs from the same modules:

- `nixosConfigurations.<user>` — a complete NixOS system (system services, GPU drivers, window manager, plus home-manager integrated as a NixOS module)
- `homeConfigurations.<user>` — standalone home-manager only, for non-NixOS machines

A `globals` attrset at the top of `flake.nix` holds shared identity values (`user`, `fullName`, `email`, `device`) and is passed into every module via `specialArgs` / `extraSpecialArgs`, so things like your git identity are defined once.

### 2. Toggleable modules

Every module defines its own `enable` option and is inert until switched on. You compose a setup by flipping flags, not by commenting out imports.

**System-level modules** (`system/`) — toggled in the root `default.nix`:

| Option                  | What it enables                                |
| ----------------------- | ---------------------------------------------- |
| `system.zsh`            | zsh as the system shell                        |
| `system.qtile_mod`      | qtile WM + picom + rofi, themed (see below)    |
| `system.gpus.amd`       | AMD GPU drivers                                |
| `gaming` (+ `enableVR`) | Steam/gaming stack, VR support                 |
| `system.LLM.ollama`     | Ollama with a configurable model storage path  |
| `extra_keybinds`        | System-wide key remapping (xremap)             |
| `system.grub_theme`     | GRUB boot menu with a vendored Evangelion theme (switches the bootloader from systemd-boot to GRUB; pick `theme` from `theme/grub/themes/` — ayanami, eva01, eva02, penpen, ramiel, seele, soryu, wunder — and a `resolution` of 720p/1080p/1440p) |
| `system.lucid`          | Hyprland session with the vendored [Lucid](https://github.com/Sn3akyy1/lucid) desktop shell (bar, dock, widgets, lock screen). Adds a session at the GDM login screen — qtile stays installed. Options: `theme` (matugen \| catppuccin-mocha \| gruvbox \| nightfox \| nord \| pywal \| tokyo-night, or a custom theme dropped into `~/.config/lucid/themes/`) and `mode` (dark \| light). Switching `theme` live-reloads the shell on rebuild |

**User-level modules** (`home-manager/`) — toggled in the root `default-home-manager.nix`:

| Option   | What it enables                                              |
| -------- | ------------------------------------------------------------ |
| `zsh`    | zsh + oh-my-zsh, vi mode, fzf-tab, zoxide, direnv, git       |
| `tmux`   | tmux with plugins (tokyo-night, resurrect, sessionx, ...)    |
| `nvim`   | Neovim with telescope, LSP, and theme                        |
| `vscode` | VS Code                                                      |

The same `home-manager/` modules are used in both modes — NixOS mode just loads them through `home-manager.nixosModules.home-manager`, so your user environment is identical either way.

### 3. Per-device overrides (`devices/`)

Device-specific settings live in `devices/<hostname>/` (extra drive mounts, device-specific toggles like the Ollama storage path) and are imported from `configuration.nix`. To add a new machine, copy `devices/mainPC/` to `devices/<newhost>/`, adjust it, and import that instead.

### Theming

The desktop theme is data, not code — change it in one place and it propagates. Everything theme-related lives under `theme/` — see **[theme/README.md](theme/README.md)** for the full catalogue with each theme's look.

```nix
# default.nix (root)
config.system.qtile_mod = {
  enable = true;
  monitors_list = 2;   # 1 or 2 monitors
  background = config.system.grub_theme.wallpaper;
  palette = "gruvbox"; # vendored Lucid palette (see below)
};
```

`palette` picks one of the palettes vendored in `theme/palettes/`. The palette's Material You colour roles map onto the theme slots (`primary` → `primaryLight`, `surface` → `primaryDark`, `secondary` → `secondaryLight`, `surface_container_high` → `secondaryDark`, `surface_variant` → `neutral`).

All `system.qtile_mod` options:

| Option          | Type          | Default   | Values / notes                                                                                          |
| --------------- | ------------- | --------- | ------------------------------------------------------------------------------------------------------- |
| `enable`        | bool          | `false`   | Installs qtile + picom + rofi                                                                            |
| `palette`       | enum          | `custom`  | `custom`, `evangelion` (the original red/green theme), `celltower` (light cream/terracotta), `catppuccin-mocha`, `gruvbox`, `nightfox`, `nord`, `pywal`, `tokyo-night` (the last six vendored from [Lucid](https://github.com/Sn3akyy1/lucid)) |
| `monitors_list` | enum `[1 2]`  | `2`       | Bar/widget layout for 1 or 2 monitors                                                                    |
| `background`    | path          | —         | Wallpaper image, written to `/etc/xdg/qtile/background`                                                  |
| `terminal`      | str           | `kitty`   | Terminal command spawned by the keybinds, written to `config.json` and read by `config.py`               |
| `theme.*`       | str (hex)     | evangelion colours | `primaryLight`, `primaryDark`, `secondaryLight`, `secondaryDark`, `neutral` — any value set overrides the selected palette |

With `palette = "custom"` the explicit theme block is used instead:

```nix
config.system.qtile_mod = {
  palette = "custom";
  theme = {
    primaryLight   = "#a22a32";
    primaryDark    = "#1e272a";
    secondaryLight = "#24e189";
    secondaryDark  = "#4b2327";
    neutral        = "#312730";
  };
};
```

To add a palette: drop a `<name>.json` with the roles `primary`, `secondary`, `surface`, `surface_container_high`, `surface_variant` into `theme/palettes/` and add `<name>` to `paletteNames` in `system/tiling_manager/qtile/default.nix`.

The qtile module (`system/tiling_manager/qtile/default.nix`) writes these values to `/etc/xdg/qtile/config.json` and the wallpaper to `/etc/xdg/qtile/background`, which `config.py` and `widgets.py` read at runtime. Any wallpaper path and any hex palette works. Editor/terminal themes live with their modules: `home-manager/nvim/theme.nix` (dracula) and the tmux module (tokyo-night).

### Boot theme (GRUB) and matching wallpapers

`theme/grub/` vendors 8 Evangelion GRUB themes (each in 720p/1080p/1440p) plus their matching 4K wallpapers:

```nix
# default.nix (root)
config.system.grub_theme = {
  enable = true;
  theme = "soryu";       # ayanami | eva01 | eva02 | penpen | ramiel | seele | soryu | wunder
  resolution = "1440p";  # 720p | 1080p | 1440p
};
```

Enabling the module switches the bootloader from systemd-boot to GRUB automatically (and back when disabled). These themes draw their menu with a bundled native GRUB module instead of a standard menu widget; the module detects the theme's `cards.cfg` and emits the matching `insmod`/`source` lines into `grub.cfg` itself, with a fallback to the plain console menu if the module fails to load. Rollback generations live in the "NixOS - All Configurations" submenu entry.

The desktop wallpaper is configured separately (`qtile_mod.background`) — it does not follow the boot theme. If you ever want them in sync, `system.grub_theme.wallpaper` is a read-only option pointing at `theme/grub/wallpapers/<theme>.png`:

```nix
config.system.qtile_mod.background = config.system.grub_theme.wallpaper;
```

### Cell Tower look (qtile/X11)

`theme/celltower/` vendors the [Cell Tower](https://gitlab.com/dejan-z/xfce-stuff/-/tree/main/Cell%20Tower) GTK theme and its 4K wallpaper. No XFCE session is installed — only the standalone apps.

```nix
# default.nix (root)
config.system.celltower.enable = true;
```

While enabled it sets, with higher priority than your explicit `qtile_mod` settings (they return when you disable it):

- `qtile_mod.palette = "celltower"` — bar colours mapped from the GTK theme's palette
- `qtile_mod.background` — the Cell Tower 4K wallpaper
- GTK 2/3 theme "Cell Tower", font "GohuFont 11 Nerd Font" (`nerd-fonts.gohufont`), plus `thunar` and `ranger` packages

The terminal stays kitty everywhere (qtile and Lucid).

The icon pack from the original dotfiles is not vendored (opendesktop.org blocks automated downloads). To add it: download it, expose it as a package with `share/icons/<name>/`, and set `system.celltower.iconTheme = { name = "<name>"; package = <pkg>; };`.

Note: the theme ships GTK 2/3 assets only, so GTK 4 apps (e.g. nautilus) keep their default look.

To add a new GRUB theme later: drop its directory into `theme/grub/themes/<name>/<resolution>/` (with a `theme.txt`), add `<name>` to `availableThemes` in `theme/grub/default.nix`, and optionally add a matching `theme/grub/wallpapers/<name>.png`. Extra wallpapers you just want to pick from can go straight into `theme/grub/wallpapers/` (or `theme/wallpapers/`) with no module changes.

### Lucid shell (Hyprland session)

`theme/lucid/` vendors the full [Lucid](https://github.com/Sn3akyy1/lucid) desktop shell (Quickshell bar, dock/launcher, widgets, lock screen) minus its ~180MB wallpaper pack. Enabling `system.lucid` adds a **Hyprland** entry to the GDM login screen — qtile is untouched, so you can move between the two per login.

```nix
# default.nix (root)
config.system.lucid = {
  enable = true;
  theme = "gruvbox";  # matugen | catppuccin-mocha | gruvbox | nightfox | nord | pywal | tokyo-night
  mode = "dark";      # dark | light
};
```

How it's wired:

- Hyprland and Quickshell come from `nixpkgs-unstable` (Lucid's `hyprland.lua` config needs Hyprland ≥ 0.55).
- `~/.config/quickshell` is a read-only link to the vendored shell; `~/.config/hypr` is refreshed from the vendored Lua config on every activation.
- `~/.config/lucid` (scripts, palettes, state) is **seeded once, then writable** — the shell's own settings edits survive rebuilds. Deleting a file there re-seeds it on the next switch.
- `theme`/`mode` are written to `~/.cache/current_theme` / `~/.cache/current_mode` on every activation, and the shell live-reloads on the change — so switching theme = edit `default.nix`, rebuild. Runtime theme picks inside the shell are overridden by the next rebuild.
- The wallpaper picker (`SUPER+B`) is pre-pointed at `theme/grub/wallpapers/`. Lucid's own ~180MB wallpaper pack is not vendored; drop images into `~/Pictures/wallpapers/` or change `wallpaperFolder` in the shell settings.
- Custom themes: drop `<name>/quickshell.json` into `~/.config/lucid/themes/` and set `system.lucid.theme = "<name>"`.
- To update the vendored shell: clone the Lucid repo and `rsync -a --delete --exclude=.git --exclude=wallpapers lucid/ theme/lucid/shell/`, then rebuild.

## Usage

Full NixOS:

```sh
sudo nixos-rebuild switch --flake .#mugen
```

Standalone home-manager (any distro):

```sh
nix build .#homeConfigurations.mugen.activationPackage
./result/activate
# or, once home-manager is installed:
home-manager switch --flake .#mugen
```

Shell aliases `hm-build` / `hm-switch` are provided by the zsh module.

## Setting up a new machine

### Prerequisites

- **NixOS install:** nothing extra needed — flakes just have to be enabled (`nix.settings.experimental-features = [ "nix-command" "flakes" ]`, already set by this config on rebuilds; enable it temporarily with `--extra-experimental-features "nix-command flakes"` for the first build).
- **Other distros:** install Nix (the [Determinate Nix installer](https://determinate.systems/nix-installer/) or the official multi-user installer) and enable flakes.

### Full NixOS machine

1. Clone the repo anywhere, e.g. `git clone git@github.com:Mugen24/dotfile-nix.git ~/dotfile-nix && cd ~/dotfile-nix`
2. Edit `globals` at the top of `flake.nix` — `user`, `fullName`, `email`. (`device` and `systemOption` exist as placeholders but aren't wired to anything yet.)
3. Generate hardware config for the machine: `sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix` (don't commit this file if it's machine-specific — copy the repo's existing one only if the hardware matches).
4. Create a device folder: copy `devices/mainPC/` to `devices/<hostname>/`, then adjust or empty `default.nix` (it contains machine-specific drive mounts — remove any UUIDs that don't exist on the new machine) and `custom-configuration.nix` (per-device toggles like the Ollama storage path).
5. Point `configuration.nix` at the new folder: change `./devices/mainPC` to `./devices/<hostname>` in its `imports`.
6. Flip module toggles in the root `default.nix` (GPU driver, qtile theme/monitors, gaming) and `default-home-manager.nix` to match the machine.
7. Build and switch:

   ```sh
   sudo nixos-rebuild switch --flake .#mugen
   ```

   (The flake output name is `${globals.user}` — if you changed `user`, use that name instead of `mugen`.)

### Standalone home-manager (non-NixOS distro)

1. Clone the repo as above.
2. Edit `globals` in `flake.nix` (`user`, `fullName`, `email`). `home.username` and `home.homeDirectory` are derived from `globals.user` automatically.
3. Pick your user modules in `default-home-manager.nix` (`zsh`, `tmux`, `nvim`, `vscode`). System modules in `default.nix` don't apply in this mode.
4. Build and activate:

   ```sh
   nix build .#homeConfigurations.<user>.activationPackage
   ./result/activate
   ```

5. From then on, `home-manager switch --flake .#<user>` (or the `hm-switch` alias) rebuilds in place.

> Note: in standalone mode nothing sets your login shell to zsh — do that yourself with `chsh -s $(which zsh)` after the first activation if you want it.


## Layout

```
flake.nix                 entry point: globals + both build modes
default.nix               system module toggles + desktop theme
default-home-manager.nix  home-manager module toggles
configuration.nix         NixOS base config, imports devices/
hardware-configuration.nix
devices/mainPC/           per-device overrides (mounts, LLM paths)
system/                   NixOS modules (qtile, gpus, Gaming, LLM, general_config)
home-manager/             user modules (zsh, tmux, nvim, vscode)
theme/                    all looks: palettes, wallpapers, GRUB themes,
                          celltower, lucid — see theme/README.md
```
