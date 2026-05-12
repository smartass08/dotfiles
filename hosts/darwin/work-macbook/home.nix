{ username, ... }:
{
  imports = [
    ../../../home/users/smartass08
    ../../../home/darwin
  ];

  home.homeDirectory = "/Users/${username}";
}
