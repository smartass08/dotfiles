{
  inputs,
  pkgs,
  username,
  ...
}:
{
  nix = {
    package = pkgs.nix;
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 15;
      };
      options = "--delete-older-than 7d";
    };

    optimise = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 4;
        Minute = 15;
      };
    };

    settings = {
      accept-flake-config = true;
      allowed-users = [
        "@admin"
        username
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      keep-derivations = true;
      keep-outputs = true;
      max-jobs = "auto";
      trusted-users = [
        "root"
        username
      ];
      warn-dirty = false;
    };
  };
}
