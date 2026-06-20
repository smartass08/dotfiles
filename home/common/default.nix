{ lib, ... }:
{
  imports = [
    ../../modules/common/options.nix
    ./cli.nix
    ./ssh.nix
    ./zsh.nix
  ];

  my.toolsets = {
    base.enable = lib.mkDefault true;
    dev.enable = lib.mkDefault true;
    diagnostics.enable = lib.mkDefault true;
    network.enable = lib.mkDefault true;
  };

  my.pkgs = {
    awscli2.enable = lib.mkDefault false;
  };
}
