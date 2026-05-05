# Common home-manager configuration shared between all hosts
{ config, pkgs, inputs, ... }:

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
in

{
  imports = [
    inputs.nixcord.homeModules.nixcord
    ../zsh.nix
    ./apps.nix
    ../modules/matugen.nix
    ../modules/spicetify.nix
  ];

  home.username = "gabzu";
  home.homeDirectory = "/home/gabzu";
  home.stateVersion = "25.05";
  # allowUnfree is set at system level (useGlobalPkgs = true)
  programs.home-manager.enable = true;

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_THEME = "Adwaita:dark";
    NIXOS_OZONE_WL = "1";
    HYPRLAND_PLUGIN_DIR = "${inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit}/lib";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };

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

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    plugins = [
      inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit
    ];
    settings = {
      plugin.hyprsplit = {
        num_workspaces = 10;
      };
      bind = [
        # switch workspace
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # move window to workspace
        "SUPER ALT, 1, movetoworkspacesilent, 1"
        "SUPER ALT, 2, movetoworkspacesilent, 2"
        "SUPER ALT, 3, movetoworkspacesilent, 3"
        "SUPER ALT, 4, movetoworkspacesilent, 4"
        "SUPER ALT, 5, movetoworkspacesilent, 5"
        "SUPER ALT, 6, movetoworkspacesilent, 6"
        "SUPER ALT, 7, movetoworkspacesilent, 7"
        "SUPER ALT, 8, movetoworkspacesilent, 8"
        "SUPER ALT, 9, movetoworkspacesilent, 9"
        "SUPER ALT, 0, movetoworkspacesilent, 10"
      ];
      cursor.no_warps = true;
      # Host-specific hypr configs will be sourced via host home.nix
    };
  };

  # Shared config files
  home.file.".config/fastfetch".source = ./fastfetch;
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
