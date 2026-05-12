{ username, ... }:
{
  imports = [
    ../../common
  ];

  home = {
    inherit username;
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
