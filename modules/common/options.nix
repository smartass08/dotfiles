{ lib, ... }:
{
  options.my = {
    apps = {
      claude.enable = lib.mkEnableOption "Claude Desktop";
      codexbar.enable = lib.mkEnableOption "CodexBar";
      cursor.enable = lib.mkEnableOption "Cursor";
      engram.enable = lib.mkEnableOption "engram";
      discord.enable = lib.mkEnableOption "Discord";
      geekbench.enable = lib.mkEnableOption "Geekbench";
      firefox.enable = lib.mkEnableOption "Firefox";
      iterm2.enable = lib.mkEnableOption "iTerm2";
      mos.enable = lib.mkEnableOption "Mos";
      nvidia-geforce-now.enable = lib.mkEnableOption "NVIDIA GeForce NOW";
      orbstack.enable = lib.mkEnableOption "OrbStack";
      outlook.enable = lib.mkEnableOption "Microsoft Outlook";
      slack.enable = lib.mkEnableOption "Slack";
      spotify.enable = lib.mkEnableOption "Spotify";
      telegram.enable = lib.mkEnableOption "Telegram";
      whatsapp.enable = lib.mkEnableOption "WhatsApp";
      vscode.enable = lib.mkEnableOption "Visual Studio Code";
      zed.enable = lib.mkEnableOption "Zed editor";
    };

    toolsets = {
      base.enable = lib.mkEnableOption "base CLI tools";
      dev.enable = lib.mkEnableOption "developer language toolchains";
      diagnostics.enable = lib.mkEnableOption "diagnostic and benchmark tools";
      network.enable = lib.mkEnableOption "network and transfer tools";
    };

    brews = {
      depot.enable = lib.mkEnableOption "Depot CLI";
      docker-compose.enable = lib.mkEnableOption "Docker Compose";
      mysql80.enable = lib.mkEnableOption "MySQL 8.0";
      nvm.enable = lib.mkEnableOption "nvm";
      postgresql17.enable = lib.mkEnableOption "PostgreSQL 17";
    };
  };
}
