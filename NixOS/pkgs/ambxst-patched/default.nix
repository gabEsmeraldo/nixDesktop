{ pkgs, lib }:

let
  system = pkgs.stdenv.hostPlatform.system;

  axctlSrc = pkgs.applyPatches {
    name = "axctl-ambxst-ignore-alpha-patched-source";
    src = pkgs.fetchFromGitHub {
      owner = "Axenide";
      repo = "axctl";
      rev = "bb47ec7e39ee81f64daa45de2eb99d9a726e49a8";
      hash = "sha256-V+G+xjZndXWACpN3YLkH1T8XePmGXJby4VpIwePKXsY=";
    };
    patches = [ ./hyprland-layer-ignore-alpha.patch ];
  };

  axctlPkg = pkgs.buildGoModule {
    pname = "axctl";
    version = "0.0.11-ambxst-ignore-alpha";
    src = axctlSrc;
    go = pkgs.go;
    subPackages = [ "." ];
    ldflags = [
      "-X"
      "main.Version=0.0.11"
    ];
    vendorHash = "sha256-4PUs37IRhUPtuXi4KU8wOUErIkVlcnaoj94zBDBsMdk=";
  };

  ambxstSrc = pkgs.fetchFromGitHub {
    owner = "Axenide";
    repo = "Ambxst";
    rev = "844cb9d3fc465ff13b504c99469fb6c4d695e399";
    hash = "sha256-osK5dWf8wMnJs+OmBMo7ND5Q9MU5HaMKcq8SosBpzmQ=";
  };

  axctlFlakeShim = {
    packages.${system}.default = axctlPkg;
  };
in
import "${ambxstSrc}/nix/packages" {
  inherit pkgs lib system;
  self = ambxstSrc;
  axctl = axctlFlakeShim;
}
