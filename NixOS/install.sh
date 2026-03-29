#!/usr/bin/env bash

# NixOS Configuration Installer
# This script sets up the NixOS configuration after a fresh NixOS install

set -e

REPO_URL="https://github.com/gabEsmeraldo/nixDesktop.git"
CONFIG_DIR="$HOME/.config"
NIXOS_DIR="$CONFIG_DIR/NixOS"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║       NixOS Configuration Installer       ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if running as root (we don't want that for cloning)
if [ "$EUID" -eq 0 ]; then
    print_error "Please run this script as a normal user, not root."
    print_warning "The script will ask for sudo when needed."
    exit 1
fi

print_banner

# Ask for machine type
echo -e "${BLUE}Which machine are you setting up?${NC}"
echo ""
echo "  1) Desktop (asphodelus)"
echo "  2) Laptop (elysium)"
echo ""
read -p "Enter your choice [1/2]: " choice

case $choice in
    1)
        HOST="desktop"
        HOSTNAME="asphodelus"
        ;;
    2)
        HOST="laptop"
        HOSTNAME="elysium"
        ;;
    *)
        print_error "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
print_step "Setting up for: ${HOSTNAME} (${HOST})"
echo ""

# Check for git
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Installing..."
    sudo nix-env -iA nixos.git
fi

# Ensure .config exists
mkdir -p "$CONFIG_DIR"

# Check if .config is already our git repo
if [ -d "$CONFIG_DIR/.git" ]; then
    print_step "Config repo already exists, pulling latest..."
    cd "$CONFIG_DIR"
    git pull
else
    # Clone to temp dir, then copy contents into .config (merging with existing files)
    print_step "Cloning configuration repository..."
    TEMP_DIR=$(mktemp -d)
    git clone "$REPO_URL" "$TEMP_DIR"

    # Copy all contents (including hidden files like .git) into .config
    print_step "Copying config files to ~/.config (merging with existing)..."
    shopt -s dotglob
    cp -r "$TEMP_DIR"/* "$CONFIG_DIR/"
    shopt -u dotglob

    rm -rf "$TEMP_DIR"
    print_step "Configuration files installed to ~/.config"
fi

cd "$NIXOS_DIR"

# For laptop: remind about hardware-configuration
if [ "$HOST" = "laptop" ]; then
    echo ""
    print_warning "IMPORTANT: You need to generate hardware-configuration.nix for this laptop!"
    echo ""
    echo "  Run this command and replace the placeholder file:"
    echo ""
    echo -e "    ${BLUE}sudo nixos-generate-config --show-hardware-config > $NIXOS_DIR/hosts/laptop/hardware-configuration.nix${NC}"
    echo ""
    read -p "Have you generated the hardware config? [y/N]: " hw_confirm
    if [[ ! $hw_confirm =~ ^[Yy]$ ]]; then
        print_warning "Please generate the hardware config before continuing."
        echo ""
        echo "After generating, run the rebuild manually:"
        echo -e "    ${BLUE}sudo nixos-rebuild switch --flake $NIXOS_DIR#$HOSTNAME${NC}"
        echo ""
        exit 0
    fi
fi

# Run the rebuild
print_step "Starting NixOS rebuild for ${HOSTNAME}..."
echo ""

sudo nixos-rebuild switch --flake "$NIXOS_DIR#$HOSTNAME"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         Installation Complete!            ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
echo ""
echo "Your system has been configured as: ${HOSTNAME}"
echo ""
echo "You may want to reboot to ensure all changes take effect:"
echo -e "    ${BLUE}sudo reboot${NC}"
echo ""
