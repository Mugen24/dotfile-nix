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
| `system.grub_theme`     | GRUB boot menu with a vendored Evangelion theme (switches the bootloader from systemd-boot to GRUB; pick `theme` from `system/grub/themes/` — ayanami, eva01, eva02, penpen, ramiel, seele, soryu, wunder — and a `resolution` of 720p/1080p/1440p) |

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

The desktop theme is data, not code — change it in one place and it propagates:

```nix
# default.nix (root)
config.system.qtile_mod = {
  enable = true;
  monitors_list = 2;                                    # 1 or 2 monitors
  background = ./system/tiling_manager/wallpapers/neon_shallows.png;
  theme = {
    primaryLight   = "#a22a32";
    primaryDark    = "#1e272a";
    secondaryLight = "#24e189";
    secondaryDark  = "#4b2327";
    neutral        = "#312730";
  };
};
```

The qtile module (`system/tiling_manager/qtile/default.nix`) writes these values to `/etc/xdg/qtile/config.json` and the wallpaper to `/etc/xdg/qtile/background`, which `config.py` and `widgets.py` read at runtime. Any wallpaper path and any hex palette works. Editor/terminal themes live with their modules: `home-manager/nvim/theme.nix` (dracula) and the tmux module (tokyo-night).

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
```
