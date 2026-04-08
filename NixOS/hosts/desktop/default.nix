# Desktop-specific system configuration (asphodelus)
{ config, pkgs, ... }:

{
  imports = [
    ../../common/configuration.nix
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "asphodelus";

  # Desktop keyboard (US International)
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";
  console.font = "ter-v24n";
  console.packages = with pkgs; [ terminus_font ];
  console.earlySetup = true;

  # Wake on LAN (desktop only)
  networking.interfaces.enp5s0.wakeOnLan.enable = true;
  networking.firewall.allowedUDPPorts = [ 9 53317 ];
  networking.firewall.allowedTCPPorts = [ 53317 ];
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns = true;
  };

  # OpenRGB (desktop RGB control)
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
    server.port = 6742;
  };

  # Docker
  virtualisation.docker.enable = true;

  # DeepCool liquid cooler
  services.hardware.deepcool-digital-linux.enable = true;
  services.udev.extraRules = ''
    # Intel RAPL energy usage file
    ACTION=="add", SUBSYSTEM=="powercap", KERNEL=="intel-rapl:0", RUN+="${pkgs.coreutils}/bin/chmod 444 /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj"

    # DeepCool HID raw devices
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3633", MODE="0666"

    # CH510 MESH DIGITAL
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="34d3", ATTRS{idProduct}=="1100", MODE="0666"
  '';

  # Nvidia GPU
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Disable Toslink suspend (desktop audio setup)
  services.pipewire.wireplumber.extraConfig."99-disable-suspend" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          { "node.name" = "~alsa_input.*"; }
          { "node.name" = "~alsa_output.*"; }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }
    ];
  };
}
