# Desktop-only applications
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Desktop Hardware ---
    deepcool-digital-linux
    openrgb-with-all-plugins
    hyprlandPlugins.hyprsplit

    # --- Gaming ---
    gamescope
    # heroic
    # hydralauncher
    # lutris
    protonplus
    prismlauncher
    # libratbag
    # piper

    # --- Desktop Tools ---
    pavucontrol
    filezilla
    qbittorrent
    nicotine-plus
    # waywall
    # blender
    # unityhub
    fooyin
    kdePackages.kdenlive

    # --- Desktop Development ---
    # arduino-ide
    # mysql-workbench
    # mysql84
    # multiviewer-for-f1
  ];
}
