{ config, lib, ... }:
let
  apps = config.my.apps;
in
{
  homebrew.taps = lib.optionals apps.codexbar.enable [ "steipete/tap" ];

  homebrew.casks =
    lib.optionals apps.codexbar.enable [ "steipete/tap/codexbar" ]
    ++ lib.optionals apps.discord.enable [ "discord" ]
    ++ lib.optionals apps.geekbench.enable [ "geekbench" ]
    ++ lib.optionals apps.iterm2.enable [ "iterm2" ]
    ++ lib.optionals apps.nvidia-geforce-now.enable [ "nvidia-geforce-now" ]
    ++ lib.optionals apps.outlook.enable [ "microsoft-outlook" ]
    ++ lib.optionals apps.spotify.enable [ "spotify" ]
    ++ lib.optionals apps.telegram.enable [ "telegram" ]
    ++ lib.optionals apps.whatsapp.enable [ "whatsapp" ]
    ++ lib.optionals apps.vscode.enable [ "visual-studio-code" ]
    ++ lib.optionals apps.zed.enable [ "zed" ];
}
