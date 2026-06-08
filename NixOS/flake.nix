{
  description = "NixOS configuration for gabzu's machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Pinned nixpkgs for packages that broke in the 2026-05-15 unstable bump
    # (discord brotli source mismatch; hyprsplit incompatible with hyprland
    # 0.55.1). Remove or bump once upstream catches up.
    nixpkgs-prev.url = "github:NixOS/nixpkgs/15f4ee454b1dce334612fa6843b3e05cf546efab";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen.url = "github:InioX/matugen";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    nixcord.url = "github:FlameFlag/nixcord";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

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
    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        ambxst-patched = pkgs.callPackage ./pkgs/ambxst-patched { };
      });

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
