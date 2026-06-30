# Laptop-specific home-manager configuration
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../common/home.nix
    ./apps.nix
  ];

  hyprland.confSources = [
    ".config/hypr/decorations.conf"
    ".config/hypr/keybinds.conf"
    ".config/hypr/envrules.conf"
    ".config/hypr/monitors.conf"
    ".config/hypr/execs.conf"
    ".local/share/ambxst/hyprland.conf"
    ".config/hypr/nix-generated.conf"
  ];

  # Laptop Hyprland config files
  home.file = {
    ".config/hypr/keybinds.conf".source = ./hypr/keybinds.conf;
    ".config/hypr/envrules.conf".source = ./hypr/envrules.conf;
    ".config/hypr/monitors.conf".source = ./hypr/monitors.conf;
    ".config/hypr/execs.conf".source = ./hypr/execs.conf;
  };
}
