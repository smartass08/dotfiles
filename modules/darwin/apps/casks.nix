{ config, lib, ... }:
let
  apps = config.my.apps;
  brews = config.my.brews;
in
{
  homebrew.taps =
    lib.optionals apps.codexbar.enable [ "steipete/tap" ]
    ++ lib.optionals apps.engram.enable [ "gentleman-programming/tap" ]
    ++ lib.optionals brews.depot.enable [ "depot/tap" ];

  homebrew.brews =
    lib.optionals brews.depot.enable [ "depot/tap/depot" ]
    ++ lib.optionals brews.docker-compose.enable [ "docker-compose" ]
    ++ lib.optionals brews.mysql80.enable [ "mysql@8.0" ]
    ++ lib.optionals brews.nvm.enable [ "nvm" ]
    ++ lib.optionals brews.postgresql17.enable [ "postgresql@17" ]
    ++ lib.optionals brews.rclone.enable [ "rclone" ];

  homebrew.casks =
    lib.optionals apps.claude.enable [ "claude" ]
    ++ lib.optionals apps.codex.enable [ "codex-app" ]
    ++ lib.optionals apps.codexbar.enable [ "steipete/tap/codexbar" ]
    ++ lib.optionals apps.cursor.enable [ "cursor" ]
    ++ lib.optionals apps.discord.enable [ "discord" ]
    ++ lib.optionals apps.firefox.enable [ "firefox" ]
    ++ lib.optionals apps.focusrite.enable [ "focusrite-control-2" ]
    ++ lib.optionals apps.geekbench.enable [ "geekbench" ]
    ++ lib.optionals apps.iterm2.enable [ "iterm2" ]
    ++ lib.optionals apps.krisp.enable [ "krisp" ]
    ++ lib.optionals apps.mos.enable [ "mos" ]
    ++ lib.optionals apps.nvidia-geforce-now.enable [ "nvidia-geforce-now" ]
    ++ lib.optionals apps.orbstack.enable [ "orbstack" ]
    ++ lib.optionals apps.outlook.enable [ "microsoft-outlook" ]
    ++ lib.optionals apps.slack.enable [ "slack" ]
    ++ lib.optionals apps.spotify.enable [ "spotify" ]
    ++ lib.optionals apps.telegram.enable [ "telegram" ]
    ++ lib.optionals apps.whatsapp.enable [ "whatsapp" ]
    ++ lib.optionals apps.vscode.enable [ "visual-studio-code" ]
    ++ lib.optionals apps.engram.enable [ "gentleman-programming/tap/engram" ]
    ++ lib.optionals apps.zed.enable [ "zed" ];

  homebrew.masApps = lib.optionalAttrs apps.amphetamine.enable {
    Amphetamine = 937984704;
  };
}
