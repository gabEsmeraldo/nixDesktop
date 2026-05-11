# Declarative KDE Plasma 6 configuration for the desktop host.
# Mirrors the most-used Hyprland keybinds so muscle memory carries
# across sessions. See hosts/desktop/hypr/keybinds.conf for the source.
{ inputs, pkgs, ... }:

let
  deejScript = pkgs.writeShellScript "plasma-launch-deej" ''
    cd /home/gabzu/.config/deej && ./deej-release
  '';
  walScript = pkgs.writeShellScript "plasma-wal-recolor" ''
    current_wall=$(readlink ~/.current.wall)
    wal -i "$current_wall"
  '';

  # Mirrors hosts/desktop/hypr/monitors.conf: DP-2 is 2560x1440 (screen 0),
  # DP-3 is the secondary (screen 1). Zen wants 2176x1224 centered on DP-2.
  zenW = 2176;
  zenH = 1224;
  monW = 2560;
  monH = 1440;
  zenX = (monW - zenW) / 2;
  zenY = (monH - zenH) / 2;
in
{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  # Autostart equivalents of the execr-once entries in
  # hosts/desktop/hypr/execs.conf for the KDE session.
  xdg.configFile = {
    "autostart/zen.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Zen Browser
      Exec=flatpak run app.zen_browser.zen
      X-KDE-AutostartScript=true
    '';
    "autostart/spotify.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Spotify
      Exec=spotify
      X-KDE-AutostartScript=true
    '';
    "autostart/discord.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Discord
      Exec=discord
      X-KDE-AutostartScript=true
    '';
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
    };

    kwin = {
      virtualDesktops = {
        rows = 1;
        number = 9;
      };
      titlebarButtons.right = [ "minimize" "maximize" "close" ];
    };

    input.keyboard = {
      layouts = [ { layout = "us"; variant = "intl"; } ];
    };

    shortcuts = {
      kwin = {
        "Window Close" = "Meta+Q";
        "Window Fullscreen" = "Meta+F";
        "Toggle Window Floating" = "Meta+W";

        "Switch Window Left"  = "Meta+Left";
        "Switch Window Right" = "Meta+Right";
        "Switch Window Up"    = "Meta+Up";
        "Switch Window Down"  = "Meta+Down";

        "Switch to Next Desktop"     = "Ctrl+Alt+Right";
        "Switch to Previous Desktop" = "Ctrl+Alt+Left";

        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch to Desktop 7" = "Meta+7";
        "Switch to Desktop 8" = "Meta+8";
        "Switch to Desktop 9" = "Meta+9";

        "Window to Desktop 1" = "Meta+Alt+1";
        "Window to Desktop 2" = "Meta+Alt+2";
        "Window to Desktop 3" = "Meta+Alt+3";
        "Window to Desktop 4" = "Meta+Alt+4";
        "Window to Desktop 5" = "Meta+Alt+5";
        "Window to Desktop 6" = "Meta+Alt+6";
        "Window to Desktop 7" = "Meta+Alt+7";
        "Window to Desktop 8" = "Meta+Alt+8";
        "Window to Desktop 9" = "Meta+Alt+9";
      };
    };

    hotkeys.commands = {
      "launch-terminal" = {
        name = "Launch terminal";
        key = "Meta+T";
        command = "kitty";
      };
      "launch-terminal-alt" = {
        name = "Launch terminal (alt)";
        key = "Meta+Shift+T";
        command = "kitty";
      };
      "launch-filemanager" = {
        name = "Launch file manager";
        key = "Meta+E";
        command = "thunar";
      };
      "launch-code" = {
        name = "Launch VS Code";
        key = "Meta+C";
        command = "code";
      };
      "launch-code-alt" = {
        name = "Launch VS Code (alt)";
        key = "Meta+Shift+C";
        command = "code";
      };
      "launch-obsidian" = {
        name = "Launch Obsidian";
        key = "Meta+Z";
        command = "obsidian";
      };
      "launch-pavucontrol" = {
        name = "Launch pavucontrol";
        key = "Meta+Shift+V";
        command = "pavucontrol";
      };
      "launch-deej" = {
        name = "Launch deej";
        key = "Meta+Shift+D";
        command = "${deejScript}";
      };
      "wal-recolor" = {
        name = "Recolor wallpaper palette";
        key = "Meta+,";
        command = "${walScript}";
      };
    };

    # Window rules — KDE equivalents of the Hyprland envrules for
    # discord, spotify, and zen. "tile on second monitor" maps to
    # screen=1 + maximized; zen uses the centered float size from
    # hosts/desktop/hypr/envrules.conf (windowrule-111).
    window-rules = [
      {
        description = "Discord on second monitor, maximized";
        match = {
          window-class = { value = "discord"; type = "substring"; match-whole = false; };
          window-types = [ "normal" ];
        };
        apply = {
          screen           = { value = 1;    apply = "initially"; };
          maximizehoriz    = { value = true; apply = "initially"; };
          maximizevert     = { value = true; apply = "initially"; };
        };
      }
      {
        description = "Spotify on second monitor, maximized";
        match = {
          window-class = { value = "spotify"; type = "substring"; match-whole = false; };
          window-types = [ "normal" ];
        };
        apply = {
          screen           = { value = 1;    apply = "initially"; };
          maximizehoriz    = { value = true; apply = "initially"; };
          maximizevert     = { value = true; apply = "initially"; };
        };
      }
      {
        description = "Zen browser centered on primary monitor";
        match = {
          window-class = { value = "app.zen_browser.zen"; type = "exact"; match-whole = true; };
          window-types = [ "normal" ];
        };
        apply = {
          screen   = { value = 0;                                          apply = "initially"; };
          position = { value = "${toString zenX},${toString zenY}";        apply = "initially"; };
          size     = { value = "${toString zenW},${toString zenH}";        apply = "initially"; };
        };
      }
    ];

    # Meta+drag to move/resize, matching Hyprland's bindm.
    # These are KWin defaults but pinning them declaratively keeps them
    # if a stray GUI tweak ever resets them.
    configFile."kwinrc"."MouseBindings"."CommandAllKey" = "Meta";
    configFile."kwinrc"."MouseBindings"."CommandAll1" = "Move";
    configFile."kwinrc"."MouseBindings"."CommandAll3" = "Resize";

    # Tapping Meta alone opens KRunner instead of the app launcher.
    configFile."kwinrc"."ModifierOnlyShortcuts"."Meta" =
      "org.kde.krunner,/App,org.kde.krunner.App,display";
  };
}
