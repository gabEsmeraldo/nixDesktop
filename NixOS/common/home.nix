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
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
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
        # switch workspace (split)
        "SUPER, 1, split:workspace, 1"
        "SUPER, 2, split:workspace, 2"
        "SUPER, 3, split:workspace, 3"
        "SUPER, 4, split:workspace, 4"
        "SUPER, 5, split:workspace, 5"
        "SUPER, 6, split:workspace, 6"
        "SUPER, 7, split:workspace, 7"
        "SUPER, 8, split:workspace, 8"
        "SUPER, 9, split:workspace, 9"
        "SUPER, 0, split:workspace, 10"

        # move window to workspace (split)
        "SUPER ALT, 1, split:movetoworkspacesilent, 1"
        "SUPER ALT, 2, split:movetoworkspacesilent, 2"
        "SUPER ALT, 3, split:movetoworkspacesilent, 3"
        "SUPER ALT, 4, split:movetoworkspacesilent, 4"
        "SUPER ALT, 5, split:movetoworkspacesilent, 5"
        "SUPER ALT, 6, split:movetoworkspacesilent, 6"
        "SUPER ALT, 7, split:movetoworkspacesilent, 7"
        "SUPER ALT, 8, split:movetoworkspacesilent, 8"
        "SUPER ALT, 9, split:movetoworkspacesilent, 9"
        "SUPER ALT, 0, split:movetoworkspacesilent, 10"
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
