{ username, ... }:
{
  imports = [
    ../../../home/users/smartass08
    ../../../home/darwin
  ];

  home.homeDirectory = "/Users/${username}";

  home.sessionPath = [
    "/opt/homebrew/opt/postgresql@17/bin"
  ];
}
