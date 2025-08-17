{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import ./overlay.nix) ];
          };
        in
        {
          name = "perfect_dark";
          packages.default = pkgs.perfectdark;
          devShell = pkgs.callPackage ./shell.nix { };
        }) // {

      overlays.perfectdark = import ./overlay.nix;
      overlays.default = import ./overlay.nix;

      homeModules.perfectdark = import ./home-modules;
      homeModules.default = import ./home-modules;
    };
}
