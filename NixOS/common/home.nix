# Common home-manager configuration shared between all hosts
{ config, pkgs, inputs, lib, ... }:

let
  tmuxResurrectStop = pkgs.writeShellApplication {
    name = "tmux-resurrect-stop";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      gawk
      gnugrep
      gnused
      procps
      tmux
    ];
    text = ''
      if tmux has-session 2>/dev/null; then
        ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh quiet
        tmux kill-server
      fi
    '';
  };

  tmuxResurrectStart = pkgs.writeShellApplication {
    name = "tmux-resurrect-start";
    runtimeInputs = with pkgs; [
      coreutils
      tmux
    ];
    text = ''
      sleep 2
      if tmux has-session 2>/dev/null; then
        ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh
      fi
    '';
  };
in

{
  imports = [
    inputs.nixcord.homeModules.nixcord
    ../modules/zsh.nix
    ./apps.nix
    ../modules/matugen.nix
    ../modules/spicetify.nix
    ../modules/hyprland-conf.nix
  ];

  home.username = "gabzu";
  home.homeDirectory = "/home/gabzu";
  home.stateVersion = "25.05";
  # allowUnfree is set at system level (useGlobalPkgs = true)
  programs.home-manager.enable = true;

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    NIXOS_OZONE_WL = "1";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4 = {
      theme = config.gtk.theme;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      shell = "zsh";
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "FiraCode Nerd Font";
      font-size = 11;
      window-padding-x = 16;
      window-padding-y = 16;
      shell-integration = "zsh";
      command = "${pkgs.zsh}/bin/zsh";
      confirm-close-surface = false;
      link-url = true;
      theme = "matugen";
    };
  };

  home.activation.ghosttyThemeInit = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.config/ghostty/themes
    if [ ! -f $HOME/.config/ghostty/themes/matugen ]; then
      touch $HOME/.config/ghostty/themes/matugen
    fi
  '';

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];
    extraConfig = ''
      set -ga terminal-overrides ",*:Tc"

      set -g status-style "bg=#1a1110,fg=#f1dfdc"
      set -g window-status-current-style "bg=#1a1110,fg=#f1dfdc,bold"
      set -g pane-border-style "fg=#4c4c4c"
      set -g pane-active-border-style "fg=#f1dfdc"
    '';
  };

  systemd.user.services.tmux-server = {
    Unit = {
      Description = "tmux server";
      Documentation = "man:tmux(1)";
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d";
      ExecStartPost = "${tmuxResurrectStart}/bin/tmux-resurrect-start";
      ExecStop = "${tmuxResurrectStop}/bin/tmux-resurrect-stop";
      KillMode = "control-group";
      RestartSec = 2;
    };
    Install.WantedBy = [ "default.target" ];
  };

  programs.nixcord = {
    enable = true;
    user = "gabzu";
    discord.vencord.enable = true;
    config = {
      frameless = true;
      plugins = {
        clientTheme = {
          enable = true;
          color = "920500";
        };
        betterFolders.enable = true;
        callTimer.enable = true;
        fakeNitro.enable = true;
        roleColorEverywhere.enable = true;
      };
    };
  };

  # Shared config files
  home.file.".config/fastfetch".source = ./fastfetch;
  home.file.".config/hypr/decorations.conf".source = ./hypr/decorations.conf;
  home.file.".config/hypr/nix-generated.conf".text = ''
    exec-once = dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target

    cursor {
      no_warps = true
    }
  '';
  xdg.configFile."kitty/kitty.conf".source = ./kitty/kitty.conf;

  # Thunar settings
  xdg.configFile."Thunar/thunarrc".text = ''
    [Configuration]
    LastShowHidden=FALSE 
    LastSortColumn=THUNAR_COLUMN_DATE
    LastSortOrder=GTK_SORT_DESCENDING
    LastView=ThunarIconView
    MiscShowThumbnails=TRUE
  '';
}
