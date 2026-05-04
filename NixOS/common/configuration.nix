# Common system configuration shared between all hosts
{ config, pkgs, ... }:

{
  imports = [
    ../flatpak.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    extra-experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Networking
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/Fortaleza";

  # Autologin
  services.getty.autologinUser = "gabzu";

  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = false;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # KDE Plasma (for apps)
  services.desktopManager.plasma6.enable = true;

  # Graphics
  hardware.graphics.enable = true;

  # Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # X11
  services.xserver.enable = true;
  # Keyboard layout is set per-host

  # Printing
  services.printing.enable = true;

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  users.users.gabzu = {
    isNormalUser = true;
    description = "gabzu";
    extraGroups = [ "networkmanager" "wheel" "dialout" "i2c" "docker" "kvm" ];
  };

  # Firefox
  programs.firefox.enable = true;

  # Android AAPT2 build + emulator runtime libs
  # (Note: systemd 258+ handles adb uaccess automatically; android-tools is already in home-manager apps.nix)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
    libcxx
    libpulseaudio
    alsa-lib
    libGL
    vulkan-loader
    fontconfig
    freetype
    dbus
    expat
    libbsd
    libdrm
    libxkbcommon
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxshmfence
  ];

  # Display Manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      save = true;
      load = true;
    };
  };

  # Flatpak
  services.flatpak.enable = true;

  # Base system packages
  environment.systemPackages = with pkgs; [
    vim
    git
    ly
    flatpak
  ];

  system.stateVersion = "25.05";
}
