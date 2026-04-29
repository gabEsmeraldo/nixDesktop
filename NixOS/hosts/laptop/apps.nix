# Laptop-only applications
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Laptop Tools ---
    brightnessctl
    android-studio
    # Add laptop-specific apps here
  ];
}
