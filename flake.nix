{
  description = "deathbox-air macOS Nix setup";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

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

    # Keep this on its own pinned nixpkgs so Numtide's binary cache can serve
    # the fast-moving agent CLIs instead of rebuilding them locally.
    llm-agents.url = "github:numtide/llm-agents.nix";
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
