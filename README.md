# NixOS Configuration

Personal NixOS configuration with multi-host support for desktop (asphodelus) and laptop (elysium).

## Quick Install (Recommended)

After a fresh NixOS install, run:

```bash
bash <(curl -s https://raw.githubusercontent.com/gabEsmeraldo/nixDesktop/main/NixOS/install.sh)
```

The script will:
- Ask if you're setting up the desktop or laptop
- Clone this repo to `~/.config`
- Guide you through hardware config generation (laptop only)
- Run the NixOS rebuild

## Manual Installation

### 1. Clone the config

```bash
cd ~
nix-shell -p git
git clone https://github.com/gabEsmeraldo/nixDesktop.git .config
```

### 2. Generate hardware config (laptop only)

```bash
sudo nixos-generate-config --show-hardware-config > ~/.config/NixOS/hosts/laptop/hardware-configuration.nix
```

### 3. Rebuild

**Desktop:**
```bash
sudo nixos-rebuild switch --flake ~/.config/NixOS#asphodelus
```

**Laptop:**
```bash
sudo nixos-rebuild switch --flake ~/.config/NixOS#elysium
```

## Structure

```
~/.config/
├── NixOS/
│   ├── flake.nix              # Entry point
│   ├── common/                # Shared configuration
│   │   ├── configuration.nix  # System config
│   │   ├── home.nix           # Home-manager config
│   │   ├── apps.nix           # Common apps
│   │   └── hypr/              # Shared Hyprland configs
│   ├── hosts/
│   │   ├── desktop/           # asphodelus
│   │   │   ├── default.nix    # Desktop system (nvidia, RGB, etc)
│   │   │   ├── home.nix       # Desktop home-manager
│   │   │   ├── apps.nix       # Desktop apps (gaming, etc)
│   │   │   └── hypr/          # Desktop Hyprland configs
│   │   └── laptop/            # elysium
│   │       ├── default.nix    # Laptop system (power mgmt, etc)
│   │       ├── home.nix       # Laptop home-manager
│   │       ├── apps.nix       # Laptop apps
│   │       └── hypr/          # Laptop Hyprland configs (ABNT2, touchpad)
│   ├── modules/               # Nix modules (spicetify, matugen)
│   └── config/                # Dotfiles (kitty, fastfetch)
└── ambxst/                    # Ambxst configuration
```

## Rebuild Alias

After installation, use the `rebuild` alias from any directory:

```bash
rebuild
```

This automatically detects the current host and rebuilds.
