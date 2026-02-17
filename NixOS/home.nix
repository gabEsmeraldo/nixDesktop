{ config, pkgs, inputs, ...}:

{
  imports = [
    inputs.nixcord.homeModules.nixcord
    ./zsh.nix
    ./apps.nix
    ./modules/matugen.nix
    ./modules/spicetify.nix
  ];
  home.username = "gabzu";
  home.homeDirectory = "/home/gabzu";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  home.sessionVariables = {
      
    # this is the key semantic signal
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";

    # GTK hint
    GTK_THEME = "Adwaita:dark";

    # Chromium / Electron
    NIXOS_OZONE_WL = "1";

    # you already have this
    HYPRLAND_PLUGIN_DIR =
      "${inputs.hyprsplit.packages.${pkgs.system}.hyprsplit}/lib";
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

  # programs.git = {
  #   enable = true;

  #   settings = {
  #     user.name = "gabesmeraldo";
  #     user.email = "gabrielcesmeraldo@gmail.com";
  #     credential.helper = "${
  #         pkgs.git.override { withLibsecret = true; }
  #       }/bin/git-credential-libsecret";
  #   };
  # };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };

  # programs.bash = {
  #   enable = false;
  #   shellAliases = {
  #     btw = "echo hyprland btw";
  #   };
  #   profileExtra = ''
  #     if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  #       exec hyprland
  #     fi
  #   '';
  # };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    plugins = [
      inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
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

      source = [
        "${config.home.homeDirectory}/.config/hypr/decorations.conf"
        "${config.home.homeDirectory}/.config/hypr/envrules.conf"
        "${config.home.homeDirectory}/.config/hypr/execs.conf"
        "${config.home.homeDirectory}/.config/hypr/keybinds.conf"
        "${config.home.homeDirectory}/.config/hypr/monitors.conf"
        "${config.home.homeDirectory}/.config/hypr/wallpaper.conf"
      ];
    };
  };

  home.file = {
    ".config/hypr/decorations.conf".source = ./config/hypr/decorations.conf;
    ".config/hypr/envrules.conf".source = ./config/hypr/envrules.conf;
    ".config/hypr/execs.conf".source = ./config/hypr/execs.conf;
    ".config/hypr/keybinds.conf".source = ./config/hypr/keybinds.conf;
    ".config/hypr/monitors.conf".source = ./config/hypr/monitors.conf;
    ".config/hypr/wallpaper.conf".source = ./config/hypr/wallpaper.conf;
  };


  # home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/fastfetch".source = ./config/fastfetch;
  xdg.configFile."kitty/kitty.conf".source = ./config/kitty/kitty.conf;
}
