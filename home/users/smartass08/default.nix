{ username, ... }:
{
  imports = [
    ../../common
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    inherit username;
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
