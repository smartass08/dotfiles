{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  environment.shells = [ pkgs.zsh ];
}
