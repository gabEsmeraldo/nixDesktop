# Common applications shared between all hosts
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- System & Terminal ---
    hyprshade
    fastfetch
    kitty
    zsh
    git
    wget
    thunar
    thunar-volman
    thunar-archive-plugin
    yazi
    kdePackages.ark
    bibata-cursors
    btop
    cava
    cbonsai
    cmatrix
    cmakeMinimal
    pkg-configUpstream
    libgcc
    gcc
    adwaita-qt
    libsecret
    # codex
    claude-code
    claude-monitor

    # --- Editors & IDEs ---
    vim
    neovim
    vscode
    code-cursor
    zed-editor
    kdePackages.kate

    # --- Development Runtimes ---
    nodejs_24
    openjdk21
    (lib.lowPrio openjdk17)
    (lib.lowPrio jdk25_headless)
    (lib.lowPrio jdk8_headless)
    texliveFull
    openssh
    docker
    docker-compose
    beamMinimal28Packages.elixir_1_19
    erlang
    android-tools
    android-studio

    # --- Communication & Social ---
    anytype
    joplin-desktop
    vlc
    telegram-desktop
    obs-studio
    localsend
    vivaldi

    # --- Life ---
    libreoffice
    kdePackages.okular
    audacity
    kdePackages.dolphin
    qimgv
    yt-dlp
    wine
    kdePackages.partitionmanager
  ];
}
