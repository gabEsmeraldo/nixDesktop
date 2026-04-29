# Desktop-only applications
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Desktop Hardware ---
    deepcool-digital-linux
    openrgb-with-all-plugins

    # --- Gaming ---
    gamescope
    heroic
    hydralauncher
    lutris
    protonplus
    prismlauncher

    # --- Desktop Tools ---
    pavucontrol
    filezilla
    qbittorrent
    nicotine-plus
    waywall
    blender
    unityhub
    fooyin

    # --- Desktop Development ---
    arduino-ide
    mysql-workbench
    mysql84
    multiviewer-for-f1
    android-studio
  ];
}
