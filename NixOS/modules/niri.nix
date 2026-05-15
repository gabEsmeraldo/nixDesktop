{ pkgs, ... }:

{
  programs.niri.enable = true;

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  xdg.portal.config.niri.default = [ "gnome" "gtk" ];
}
