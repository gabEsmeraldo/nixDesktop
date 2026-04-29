# Laptop-only applications
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Laptop Tools ---
    brightnessctl
    # Add laptop-specific apps here
  ];
}
