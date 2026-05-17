{ lib, ... }:
{
  imports = [
    ../../common/options.nix
    ../apps/casks.nix
    ../defaults.nix
    ../environment.nix
    ../fonts.nix
    ../homebrew.nix
    ../nix.nix
    ../zsh.nix
  ];

  my.apps = {
    codexbar.enable = lib.mkDefault true;
    discord.enable = lib.mkDefault true;
    geekbench.enable = lib.mkDefault true;
    iterm2.enable = lib.mkDefault true;
    nvidia-geforce-now.enable = lib.mkDefault true;
    outlook.enable = lib.mkDefault true;
    spotify.enable = lib.mkDefault true;
    telegram.enable = lib.mkDefault true;
    whatsapp.enable = lib.mkDefault true;
    vscode.enable = lib.mkDefault true;
    zed.enable = lib.mkDefault true;
  };
}
