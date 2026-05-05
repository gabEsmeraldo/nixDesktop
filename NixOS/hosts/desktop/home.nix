# Desktop-specific home-manager configuration
{ config, pkgs, inputs, ... }:

let
  easyEffectsGui = pkgs.writeShellApplication {
    name = "easyeffects-gui";
    runtimeInputs = with pkgs; [
      coreutils
      easyeffects
    ];
    text = ''
      easyeffects -q >/dev/null 2>&1 || true
      sleep 0.3
      exec easyeffects "$@"
    '';
  };
in

{
  imports = [
    ../../common/home.nix
    ./apps.nix
  ];

  home.packages = [
    easyEffectsGui
  ];

  # Desktop-specific Hyprland config sources
  wayland.windowManager.hyprland.settings.source = [
    "${config.home.homeDirectory}/.config/hypr/decorations.conf"
    "${config.home.homeDirectory}/.config/hypr/keybinds.conf"
    "${config.home.homeDirectory}/.config/hypr/envrules.conf"
    "${config.home.homeDirectory}/.config/hypr/monitors.conf"
    "${config.home.homeDirectory}/.config/hypr/execs.conf"
    "${config.home.homeDirectory}/.config/hypr/wallpaper.conf"
    "~/.local/share/ambxst/hyprland.conf"
  ];

  # Desktop-specific tablet input
  wayland.windowManager.hyprland.settings.input = {
    tablet = {
      output = "DP-2";
    };
  };

  # Desktop Hyprland config files
  home.file = {
    ".local/share/applications/com.github.wwmm.easyeffects.desktop".text = ''
      [Desktop Entry]
      Name=Easy Effects
      GenericName=Equalizer, Compressor and Other Audio Effects
      Comment=Simple audio effects
      Keywords=limiter;compressor;reverberation;equalizer;autovolume;
      Categories=AudioVideo;Audio;
      Exec=${easyEffectsGui}/bin/easyeffects-gui
      Icon=com.github.wwmm.easyeffects
      StartupWMClass=Easy Effects
      StartupNotify=true
      Terminal=false
      Type=Application
    '';
    ".config/hypr/decorations.conf".source = ../../common/hypr/decorations.conf;
    ".config/hypr/keybinds.conf".source = ./hypr/keybinds.conf;
    ".config/hypr/envrules.conf".source = ./hypr/envrules.conf;
    ".config/hypr/monitors.conf".source = ./hypr/monitors.conf;
    ".config/hypr/execs.conf".source = ./hypr/execs.conf;
    ".config/hypr/wallpaper.conf".source = ./hypr/wallpaper.conf;
  };
}
