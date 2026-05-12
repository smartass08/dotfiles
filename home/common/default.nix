{ lib, ... }:
{
  imports = [
    ../../modules/common/options.nix
    ./cli.nix
    ./zsh.nix
  ];

  my.toolsets = {
    base.enable = lib.mkDefault true;
    dev.enable = lib.mkDefault true;
    diagnostics.enable = lib.mkDefault true;
    network.enable = lib.mkDefault true;
  };
}
