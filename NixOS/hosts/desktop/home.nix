# Desktop-specific home-manager configuration
{ config, lib, pkgs, inputs, ... }:

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
    ./plasma.nix
  ];

  home.packages = [
    easyEffectsGui
  ];

  home.sessionVariables.HYPRLAND_PLUGIN_DIR =
    "${pkgs.hyprlandPlugins.hyprsplit}/lib";

  home.activation.writeHyprlandConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/hypr"
    rm -f "$HOME/.config/hypr/hyprland.conf"
    cat > "$HOME/.config/hypr/hyprland.conf" <<EOF
source=${config.home.homeDirectory}/.config/hypr/decorations.conf
source=${config.home.homeDirectory}/.config/hypr/keybinds.conf
source=${config.home.homeDirectory}/.config/hypr/envrules.conf
source=${config.home.homeDirectory}/.config/hypr/monitors.conf
source=${config.home.homeDirectory}/.config/hypr/wallpaper.conf
source=${config.home.homeDirectory}/.local/share/ambxst/hyprland.conf
source=${config.home.homeDirectory}/.config/hypr/nix-generated-desktop.conf
source=${config.home.homeDirectory}/.config/hypr/nix-generated.conf
source=${config.home.homeDirectory}/.config/hypr/execs.conf
EOF
  '';

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
    ".config/hypr/nix-generated-desktop.conf".text = ''
      plugin = ${pkgs.hyprlandPlugins.hyprsplit}/lib/libhyprsplit.so

      plugin {
        hyprsplit {
          num_workspaces = 10
        }
      }

      bind = SUPER, 1, split:workspace, 1
      bind = SUPER, 2, split:workspace, 2
      bind = SUPER, 3, split:workspace, 3
      bind = SUPER, 4, split:workspace, 4
      bind = SUPER, 5, split:workspace, 5
      bind = SUPER, 6, split:workspace, 6
      bind = SUPER, 7, split:workspace, 7
      bind = SUPER, 8, split:workspace, 8
      bind = SUPER, 9, split:workspace, 9
      bind = SUPER, 0, split:workspace, 10

      bind = SUPER ALT, 1, split:movetoworkspacesilent, 1
      bind = SUPER ALT, 2, split:movetoworkspacesilent, 2
      bind = SUPER ALT, 3, split:movetoworkspacesilent, 3
      bind = SUPER ALT, 4, split:movetoworkspacesilent, 4
      bind = SUPER ALT, 5, split:movetoworkspacesilent, 5
      bind = SUPER ALT, 6, split:movetoworkspacesilent, 6
      bind = SUPER ALT, 7, split:movetoworkspacesilent, 7
      bind = SUPER ALT, 8, split:movetoworkspacesilent, 8
      bind = SUPER ALT, 9, split:movetoworkspacesilent, 9
      bind = SUPER ALT, 0, split:movetoworkspacesilent, 10
    '';
  };
}
