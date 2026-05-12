{
  inputs,
  hostname,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../common/options.nix
  ];

  networking.hostName = hostname;

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.lix;
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        username
      ];
      warn-dirty = false;
    };
  };

  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
}
