# NixOS config

Flake-based configuration for two machines:

| Host | Hostname | Notes |
|------|----------|-------|
| `desktop` | asphodelus | Nvidia, OpenRGB, DeepCool, hyprsplit |
| `laptop` | elysium | Intel graphics, TLP power management |

`asphodelus` and `elysium` work as aliases, so `nixos-rebuild switch --flake .` picks the right config from the machine's hostname.

## Layout

```
flake.nix              Inputs + mkHost helper; one line per host
common/
  configuration.nix    System config shared by all hosts (boot, audio, user, ...)
  home.nix             Home-manager config shared by all hosts (gtk, tmux, ...)
  apps.nix             Packages installed on every host
  hypr/, kitty/, ...   Shared dotfiles
hosts/<name>/
  default.nix          Host-specific system config (imports common/configuration.nix)
  home.nix             Host-specific home config (imports common/home.nix)
  apps.nix             Host-only packages
  hardware-configuration.nix
  hypr/                Host-specific hyprland files (keybinds, monitors, ...)
modules/               Reusable modules (zsh, flatpak, matugen, spicetify,
                       keyboard-debounce, hyprland-conf)
pkgs/                  Custom packages (ambxst-patched)
```

## Hyprland config

`modules/hyprland-conf.nix` generates `~/.config/hypr/hyprland.conf` from the
ordered file list each host sets in `hyprland.confSources` (in `hosts/<name>/home.nix`).
The individual `.conf` files live in `hosts/<name>/hypr/` and `common/hypr/`.

## Usage

```sh
sudo nixos-rebuild switch --flake ~/.config/NixOS
```
