{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- System & Terminal ---
    hyprshade
    fastfetch
    kitty
    # alacritty
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

    # --- Editors & IDEs ---
    vim
    neovim
    vscode
    code-cursor
    zed
    kdePackages.kate
    arduino-ide

    # --- Development Runtimes ---
    nodejs_24
    # Java Versions (Using lowPrio to prevent jexec collisions)
    openjdk21                  # Primary version
    (lib.lowPrio openjdk17)    # Secondary
    (lib.lowPrio jdk8_headless)     # Legacy
    texliveFull
    openssh
    mysql-workbench
    mysql84
    

    # --- Communication & Social ---
    discord
    # vesktop
    # vencord
    # spotify
    anytype
    joplin-desktop
    # steam
    vlc
    telegram-desktop

    # Life
    libreoffice
    kdePackages.okular
    audacity
    kdePackages.dolphin
    qimgv
    joplin-desktop
    multiviewer-for-f1
    yt-dlp
    davinci-resolve
    # easyeffects
    wine
    kdePackages.partitionmanager

    #Desktop only
    gamescope
    pavucontrol
    deepcool-digital-linux
    filezilla
    openrgb-with-all-plugins
    heroic
    hydralauncher
    lutris
    protonplus
    qbittorrent
    nicotine-plus
    prismlauncher
    # mangayomi
    blender
    fooyin

    #delete
    google-chrome
  ];
}
