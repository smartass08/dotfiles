{ username, ... }:
{
  imports = [
    ../modules/home/cli.nix
    ../modules/home/iterm2.nix
    ../modules/home/zsh.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
