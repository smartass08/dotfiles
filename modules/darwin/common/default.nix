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

  services.openssh.enable = true;

  my.apps = {
    claude.enable = lib.mkDefault true;
    codexbar.enable = lib.mkDefault true;
    cursor.enable = lib.mkDefault false;
    engram.enable = lib.mkDefault true;
    discord.enable = lib.mkDefault true;
    firefox.enable = lib.mkDefault false;
    geekbench.enable = lib.mkDefault true;
    iterm2.enable = lib.mkDefault true;
    mos.enable = lib.mkDefault true;
    nvidia-geforce-now.enable = lib.mkDefault true;
    orbstack.enable = lib.mkDefault false;
    outlook.enable = lib.mkDefault true;
    slack.enable = lib.mkDefault false;
    spotify.enable = lib.mkDefault true;
    telegram.enable = lib.mkDefault true;
    whatsapp.enable = lib.mkDefault true;
    vscode.enable = lib.mkDefault true;
    zed.enable = lib.mkDefault true;
  };

  my.brews = {
    depot.enable = lib.mkDefault false;
    docker-compose.enable = lib.mkDefault false;
    mysql80.enable = lib.mkDefault false;
    nvm.enable = lib.mkDefault false;
    postgresql17.enable = lib.mkDefault false;
    rclone.enable = lib.mkDefault true;
  };
}
