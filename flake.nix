{
  description = "deathbox-air macOS Nix setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      darwin,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      flake =
        let
          hostLib = import ./lib/hosts.nix { inherit inputs; };
        in
        {
          inherit (hostLib) darwinConfigurations nixosConfigurations;
          lib = {
            inherit (hostLib)
              darwinHosts
              mkDarwinHost
              mkNixosHost
              nixosHosts
              ;
          };
        };

      perSystem =
        {
          lib,
          pkgs,
          system,
          ...
        }:
        {
          apps = lib.optionalAttrs pkgs.stdenv.isDarwin {
            darwin-rebuild = {
              type = "app";
              program = "${darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild";
            };
          };

          formatter = pkgs.nixfmt;
        };
    };
}
