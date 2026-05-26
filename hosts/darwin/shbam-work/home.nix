{ username, ... }:
{
  imports = [
    ../../../home/users/smartass08
    ../../../home/darwin
  ];

  home.homeDirectory = "/Users/${username}";

  home.sessionPath = [
    "/opt/homebrew/opt/mysql@8.0/bin"
    "/opt/homebrew/opt/postgresql@17/bin"
  ];

  xdg.configFile."docker/config.json".text = builtins.toJSON {
    cliPluginsExtraDirs = [
      "/opt/homebrew/lib/docker/cli-plugins"
    ];
  };
}
