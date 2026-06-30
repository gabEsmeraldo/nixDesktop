# Common system configuration shared between all hosts
{ config, pkgs, inputs, ... }:

{
  imports = [
    ../modules/flatpak.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Nix settings
  nixpkgs.config.allowUnfree = true;

  # Workaround for upstream nixpkgs breakage on the 2026-05-15 unstable bump:
  #   - discord: brotli/tar source mismatch
  #   - hyprsplit 0.54.2: source incompatible with bundled hyprland 0.55.1
  # Pull the affected packages from the prior known-good nixpkgs. hyprland
  # itself is overridden too so plugin ABI stays consistent with the plugin.
  nixpkgs.overlays = [
    (final: prev:
      let
        prevPkgs = import inputs.nixpkgs-prev {
          inherit (final.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
      in {
        inherit (prevPkgs) discord discord-ptb discord-canary discord-development hyprland hyprlandPlugins;
      })
  ];
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
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
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
    extraGroups = [ "networkmanager" "wheel" "dialout" "i2c" "docker" "kvm" "input" ];
  };

  # Firefox
  programs.firefox.enable = true;

  # GPU screen recorder (enables non-portal backend with required setuid wrapper)
  programs.gpu-screen-recorder.enable = true;
  # ambxst checks /run/wrappers/bin/gpu-screen-recorder to enable direct
  # (region/window/screen) capture modes; nixpkgs only wraps gsr-kms-server,
  # so add a wrapper for the main binary as well.
  security.wrappers.gpu-screen-recorder = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_nice+ep";
    source = "${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder";
  };

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
    libx11
    libxi
    libxcursor
    libxrandr
    libxrender
    libxtst
    libxcb
    libxshmfence
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
