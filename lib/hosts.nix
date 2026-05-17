{ inputs }:
let
  inherit (inputs) darwin home-manager nixpkgs;
  lib = nixpkgs.lib;
  defaultUsername = "smartass08";

  mkDarwinHost =
    {
      hostname,
      system ? "aarch64-darwin",
      username ? defaultUsername,
      modules ? [ ],
      homeModule,
      homeModules ? [ ],
    }:
    let
      hostSpec = {
        os = "darwin";
        inherit hostname system username;
      };
      specialArgs = {
        inherit
          inputs
          hostname
          hostSpec
          username
          ;
      };
    in
    darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [
        ../modules/darwin/common
        home-manager.darwinModules.home-manager
        (
          { pkgs, ... }:
          {
            nixpkgs = {
              hostPlatform = system;
              config.allowUnfree = true;
            };

            networking = {
              hostName = hostname;
              localHostName = hostname;
              computerName = hostname;
            };

            users.users.${username} = {
              name = username;
              home = "/Users/${username}";
              shell = pkgs.zsh;
            };

            system.primaryUser = username;

            environment.variables = {
              LANG = "en_US.UTF-8";
            };

            programs.man.enable = true;

            # Match nix-darwin's current default for fresh multi-user installs.
            ids.gids.nixbld = 350;

            # Read `darwin-rebuild changelog` before changing this after first switch.
            system.stateVersion = 6;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${username} = {
                imports = [ homeModule ] ++ homeModules;
              };
            };
          }
        )
      ]
      ++ modules;
    };

  mkNixosHost =
    {
      hostname,
      system ? "x86_64-linux",
      username ? defaultUsername,
      modules ? [ ],
      homeModule ? null,
      homeModules ? [ ],
    }:
    let
      hostSpec = {
        os = "nixos";
        inherit hostname system username;
      };
      specialArgs = {
        inherit
          inputs
          hostname
          hostSpec
          username
          ;
      };
      userHomeModules = lib.optionals (homeModule != null) [ homeModule ] ++ homeModules;
    in
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ../modules/nixos/common
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            users.${username} = {
              imports = userHomeModules;
            };
          };
        }
      ]
      ++ modules;
    };

  darwinHosts = {
    deathbox-air = {
      hostname = "deathbox-air";
      system = "aarch64-darwin";
      username = defaultUsername;
      modules = [ ../hosts/darwin/deathbox-air ];
      homeModule = ../hosts/darwin/deathbox-air/home.nix;
    };

    deathbox-mini = {
      hostname = "deathbox-mini";
      system = "aarch64-darwin";
      username = defaultUsername;
      modules = [ ../hosts/darwin/deathbox-mini ];
      homeModule = ../hosts/darwin/deathbox-mini/home.nix;
    };

    shbam-work = {
      hostname = "shbam-work";
      system = "aarch64-darwin";
      username = defaultUsername;
      modules = [ ../hosts/darwin/shbam-work ];
      homeModule = ../hosts/darwin/shbam-work/home.nix;
    };

    work-macbook = {
      hostname = "work-macbook";
      system = "aarch64-darwin";
      username = defaultUsername;
      modules = [ ../hosts/darwin/work-macbook ];
      homeModule = ../hosts/darwin/work-macbook/home.nix;
    };
  };

  nixosHosts = { };
in
{
  inherit
    darwinHosts
    mkDarwinHost
    mkNixosHost
    nixosHosts
    ;

  darwinConfigurations = lib.mapAttrs (_: mkDarwinHost) darwinHosts;
  nixosConfigurations = lib.mapAttrs (_: mkNixosHost) nixosHosts;
}
