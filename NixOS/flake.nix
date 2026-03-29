{
  description = "NixOS configuration for gabzu's machines";

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

    nixcord.url = "github:FlameFlag/nixcord";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    # Helper function to create a NixOS system
    mkHost = { hostName, hostPath }: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        hostPath
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.gabzu = import ./hosts/${hostName}/home.nix;
          };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  in {
    nixosConfigurations = {
      # Desktop (asphodelus)
      desktop = mkHost {
        hostName = "desktop";
        hostPath = ./hosts/desktop;
      };

      # Keep old name as alias for compatibility
      asphodelus = mkHost {
        hostName = "desktop";
        hostPath = ./hosts/desktop;
      };

      # Laptop
      laptop = mkHost {
        hostName = "laptop";
        hostPath = ./hosts/laptop;
      };

      # Laptop alias
      elysium = mkHost {
        hostName = "laptop";
        hostPath = ./hosts/laptop;
      };
    };
  };
}
