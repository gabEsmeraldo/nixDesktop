# Desktop-specific home-manager configuration
{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../common/home.nix
    ./apps.nix
  ];

  # Desktop-specific Hyprland config sources
  wayland.windowManager.hyprland.settings.source = [
    "${config.home.homeDirectory}/.config/hypr/decorations.conf"
    "${config.home.homeDirectory}/.config/hypr/keybinds.conf"
    "${config.home.homeDirectory}/.config/hypr/envrules.conf"
    "${config.home.homeDirectory}/.config/hypr/monitors.conf"
    "${config.home.homeDirectory}/.config/hypr/execs.conf"
    "${config.home.homeDirectory}/.config/hypr/wallpaper.conf"
  ];

  # Desktop-specific tablet input
  wayland.windowManager.hyprland.settings.input = {
    tablet = {
      output = "DP-2";
    };
  };

  # Desktop Hyprland config files
  home.file = {
    ".config/hypr/decorations.conf".source = ../../common/hypr/decorations.conf;
    ".config/hypr/keybinds.conf".source = ./hypr/keybinds.conf;
    ".config/hypr/envrules.conf".source = ./hypr/envrules.conf;
    ".config/hypr/monitors.conf".source = ./hypr/monitors.conf;
    ".config/hypr/execs.conf".source = ./hypr/execs.conf;
    ".config/hypr/wallpaper.conf".source = ./hypr/wallpaper.conf;
  };
}
