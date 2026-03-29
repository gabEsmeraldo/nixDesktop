# Laptop-specific system configuration
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../common/configuration.nix
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "elysium";

  # Laptop keyboard (ABNT2)
  services.xserver.xkb = {
    layout = "br";
    variant = "abnt2";
  };
  console.keyMap = "br-abnt2";

  # Laptop power management (disable power-profiles-daemon as it conflicts with tlp)
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    };
  };

  # Battery optimization
  powerManagement.enable = true;

  # Backlight control
  programs.light.enable = true;

  # Touchpad (if needed beyond defaults)
  # services.libinput.enable = true;

  # You may need different GPU config here
  # For Intel:
  # hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];

  # For AMD:
  # services.xserver.videoDrivers = ["amdgpu"];

  # For hybrid (Intel + Nvidia):
  # hardware.nvidia.prime = {
  #   offload.enable = true;
  #   intelBusId = "PCI:0:2:0";
  #   nvidiaBusId = "PCI:1:0:0";
  # };
}
