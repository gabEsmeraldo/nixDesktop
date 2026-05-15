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
    inputs.niri.homeModules.niri
  ];

  programs.niri.settings = {
    outputs."DP-2" = {
      mode = { width = 2560; height = 1440; refresh = 180.0; };
      position = { x = 0; y = 0; };
    };
    outputs."DP-3" = {
      mode = null; # auto
      transform.rotation = 90;
    };

    input = {
      keyboard.xkb = { layout = "us"; variant = "intl"; };
      mouse.accel-speed = -0.4;
      tablet.map-to-output = "DP-2";
    };

    layout = {
      gaps = 8;
      border = {
        width = 2;
        active.color = "#cba6f7";
        inactive.color = "#313244";
      };
    };

    workspaces = {
      browser = {};
      code = {};
      media = {};
      gaming = {};
      social = {};
    };

    spawn-at-startup = [
      { command = [ "flatpak" "run" "app.zen_browser.zen" ]; }
      { command = [ "spotify" ]; }
      { command = [ "discord" ]; }
      { command = [ "openrgb" "--startminimized" "-p" "Rosio" ]; }
      { command = [ "sudo" "deepcool-digital-linux" ]; }
      { command = [ "localsend_app" "--hidden" ]; }
      { command = [ "linux-wallpaperengine" "--screen-root" "DP-2" "--silent" "3241251648" ]; }
      { command = [ "linux-wallpaperengine" "--screen-root" "DP-3" "--silent" "2984411413" ]; }
    ];

    window-rules = [
      # Discord and Spotify on social workspace
      { matches = [{ app-id = "^discord$"; }]; open-on-workspace = "social"; }
      { matches = [{ app-id = "^Spotify$"; title = "^Spotify.*"; }]; open-on-workspace = "social"; }
      # Browser on browser workspace
      { matches = [{ app-id = "^zen$"; }]; open-on-workspace = "browser"; }
      # Terminal sizing
      { matches = [{ app-id = "^com\\.mitchellh\\.ghostty$"; }]; default-column-width.fixed = 1200; }
      { matches = [{ app-id = "^kitty$"; }]; default-column-width.fixed = 1200; }
      # Games fullscreen
      { matches = [{ app-id = "^WarThunder$"; }]; open-fullscreen = true; }
    ];

    binds = with { c = "Ctrl"; s = "Super"; sh = "Shift"; a = "Alt"; }; {
      # Apps
      "${s}+T".action.spawn = [ "ghostty" ];
      "${s}+${sh}+T".action.spawn = [ "kitty" ];
      "${s}+E".action.spawn = [ "thunar" ];
      "${s}+C".action.spawn = [ "code" ];
      "${s}+Z".action.spawn = [ "md.obsidian.Obsidian" ];
      "${s}+${sh}+V".action.spawn = [ "pavucontrol" ];
      "${s}+${sh}+D".action.spawn = [ "sh" "-c" "cd /home/gabzu/.config/deej && ./deej-release" ];
      "${s}+Comma".action.spawn = [ "ambxst" "run" "wallpapers" ];

      # Window management
      "${s}+Q".action.close-window = {};
      "${s}+W".action.toggle-window-floating = {};
      "${s}+F".action.fullscreen-window = {};

      # Focus navigation
      "${s}+Left".action.focus-column-left = {};
      "${s}+Right".action.focus-column-right = {};
      "${s}+Up".action.focus-window-up = {};
      "${s}+Down".action.focus-window-down = {};

      # Move windows
      "${s}+${sh}+Left".action.move-column-left = {};
      "${s}+${sh}+Right".action.move-column-right = {};
      "${s}+${sh}+Up".action.move-window-up = {};
      "${s}+${sh}+Down".action.move-window-down = {};

      # Workspace navigation (Ctrl+Alt+Arrow — same as Hyprland)
      "${c}+${a}+Right".action.focus-workspace-down = {};
      "${c}+${a}+Left".action.focus-workspace-up = {};

      # Workspace by number (Super+0-9)
      "${s}+1".action.focus-workspace = 1;
      "${s}+2".action.focus-workspace = 2;
      "${s}+3".action.focus-workspace = 3;
      "${s}+4".action.focus-workspace = 4;
      "${s}+5".action.focus-workspace = 5;
      "${s}+6".action.focus-workspace = 6;
      "${s}+7".action.focus-workspace = 7;
      "${s}+8".action.focus-workspace = 8;
      "${s}+9".action.focus-workspace = 9;
      "${s}+0".action.focus-workspace = 10;

      # Move window to workspace (Super+Alt+0-9)
      "${s}+${a}+1".action.move-window-to-workspace = 1;
      "${s}+${a}+2".action.move-window-to-workspace = 2;
      "${s}+${a}+3".action.move-window-to-workspace = 3;
      "${s}+${a}+4".action.move-window-to-workspace = 4;
      "${s}+${a}+5".action.move-window-to-workspace = 5;
      "${s}+${a}+6".action.move-window-to-workspace = 6;
      "${s}+${a}+7".action.move-window-to-workspace = 7;
      "${s}+${a}+8".action.move-window-to-workspace = 8;
      "${s}+${a}+9".action.move-window-to-workspace = 9;
      "${s}+${a}+0".action.move-window-to-workspace = 10;

      # Desktop-specific: DAC switching
      "${s}+${c}+1".action.spawn = [ "sh" "/home/gabzu/.config/scripts/switchDAC.sh" ];
      "${s}+${c}+2".action.spawn = [ "sh" "/home/gabzu/.config/scripts/switchEDIFIER.sh" ];

      # Scroll through workspaces
      "${s}+WheelScrollDown".action.focus-workspace-down = {};
      "${s}+WheelScrollUp".action.focus-workspace-up = {};

      # Column sizing
      "${s}+Minus".action.set-column-width = "-10%";
      "${s}+Equal".action.set-column-width = "+10%";

      # Media keys
      "XF86AudioRaiseVolume".action.spawn = [ "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+" ];
      "XF86AudioLowerVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];
      "XF86AudioMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
      "XF86AudioMicMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
      "XF86AudioNext".action.spawn = [ "playerctl" "next" ];
      "XF86AudioPrev".action.spawn = [ "playerctl" "previous" ];
      "XF86AudioPlay".action.spawn = [ "playerctl" "play-pause" ];
    };
  };

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
