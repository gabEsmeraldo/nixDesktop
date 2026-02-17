# Installation process
### Enter .config folder
```cd .config```
### clone the config
```nix-shell -p git```
```git clone https://github.com/gabesmeraldo/nixDesktop.git .```
### Switch
```sudo nixos-rebuild switch --flake ~/.config/NixOS#asphodelus```

## Changing hardware Config if needed
### removing the git one
```rm  ~/.config/NixOS/hardware-configuration.nix```
### copying the generated one
```cp /etc/nixos/hardware-configuration.nix ~/.config/NixOS/```
