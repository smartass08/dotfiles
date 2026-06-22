{ lib, ... }:
{
  imports = [
    ../../common/options.nix
    ../apps/amphetamine-power-protect.nix
    ../apps/casks.nix
    ../apps/epson-v39ii-driver.nix
    ../defaults.nix
    ../environment.nix
    ../fonts.nix
    ../homebrew.nix
    ../nix.nix
    ../zsh.nix
  ];

  services.openssh.enable = true;

  my.apps = {
    amphetamine.enable = lib.mkDefault true;
    claude.enable = lib.mkDefault true;
    codex.enable = lib.mkDefault true;
    codexbar.enable = lib.mkDefault true;
    cursor.enable = lib.mkDefault false;
    engram.enable = lib.mkDefault true;
    discord.enable = lib.mkDefault true;
    epson-v39ii-driver.enable = lib.mkDefault false;
    firefox.enable = lib.mkDefault false;
    focusrite.enable = lib.mkDefault false;
    geekbench.enable = lib.mkDefault true;
    iterm2.enable = lib.mkDefault true;
    jetbrains-toolbox.enable = lib.mkDefault true;
    krisp.enable = lib.mkDefault false;
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
