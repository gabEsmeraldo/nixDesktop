# Laptop-specific home-manager configuration
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../common/home.nix
    ./apps.nix
  ];

  home.activation.writeHyprlandConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/hypr"
    cat > "$HOME/.config/hypr/hyprland.conf" <<EOF
source=${config.home.homeDirectory}/.config/hypr/decorations.conf
source=${config.home.homeDirectory}/.config/hypr/keybinds.conf
source=${config.home.homeDirectory}/.config/hypr/envrules.conf
source=${config.home.homeDirectory}/.config/hypr/monitors.conf
source=${config.home.homeDirectory}/.config/hypr/execs.conf
source=${config.home.homeDirectory}/.local/share/ambxst/hyprland.conf
source=${config.home.homeDirectory}/.config/hypr/nix-generated.conf
EOF
  '';

  # Laptop Hyprland config files
  home.file = {
    ".config/hypr/decorations.conf".source = ../../common/hypr/decorations.conf;
    ".config/hypr/keybinds.conf".source = ./hypr/keybinds.conf;
    ".config/hypr/envrules.conf".source = ./hypr/envrules.conf;
    ".config/hypr/monitors.conf".source = ./hypr/monitors.conf;
    ".config/hypr/execs.conf".source = ./hypr/execs.conf;
  };
}
