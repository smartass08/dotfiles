{
  pkgs,
  username,
  hostname,
  ...
}:
{
  imports = [
    ../../../modules/darwin/defaults.nix
    ../../../modules/darwin/environment.nix
    ../../../modules/darwin/fonts.nix
    ../../../modules/darwin/homebrew.nix
    ../../../modules/darwin/nix.nix
    ../../../modules/darwin/zsh.nix
  ];

  networking = {
    hostName = hostname;
    localHostName = hostname;
    computerName = hostname;
  };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  system.primaryUser = username;

  environment.variables = {
    LANG = "en_US.UTF-8";
  };

  programs.man.enable = true;

  # Match nix-darwin's current default for fresh multi-user installs.
  ids.gids.nixbld = 350;

  # Read `darwin-rebuild changelog` before changing this after first switch.
  system.stateVersion = 6;
}
