{ config, lib, ... }:
let
  apps = config.my.apps;
in
{
  homebrew.casks =
    lib.optionals apps.discord.enable [ "discord" ]
    ++ lib.optionals apps.geekbench.enable [ "geekbench" ]
    ++ lib.optionals apps.iterm2.enable [ "iterm2" ]
    ++ lib.optionals apps.outlook.enable [ "microsoft-outlook" ]
    ++ lib.optionals apps.spotify.enable [ "spotify" ]
    ++ lib.optionals apps.telegram.enable [ "telegram" ]
    ++ lib.optionals apps.vscode.enable [ "visual-studio-code" ]
    ++ lib.optionals apps.zed.enable [ "zed" ];
}
