{
  description = "NixOS configuration for gabzu's desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen.url = "github:InioX/matugen";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # --- HYPRLAND & PLUGINS ---
    hyprland.url = "github:hyprwm/Hyprland";
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      asphodelus = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs system; };

              # --- THE FIX ---
              # We ONLY import home.nix. We do NOT define settings here.
              users.gabzu = import ./home.nix;
            };
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
  };
}