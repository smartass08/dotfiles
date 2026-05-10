{
  description = "deathbox-air macOS Nix setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
      self,
      nixpkgs,
      darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      username = "smartass08";
      hostname = "deathbox-air";
      specialArgs = {
        inherit
          inputs
          username
          hostname
          ;
      };
    in
    {
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/darwin/deathbox-air
          home-manager.darwinModules.home-manager
          {
            nixpkgs = {
              hostPlatform = system;
              config.allowUnfree = true;
            };

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${username} = import ./home/smartass08.nix;
            };
          }
        ];
      };

      apps.${system}.darwin-rebuild = {
        type = "app";
        program = "${darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild";
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
