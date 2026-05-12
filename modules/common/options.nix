{ lib, ... }:
{
  options.my = {
    apps = {
      discord.enable = lib.mkEnableOption "Discord";
      geekbench.enable = lib.mkEnableOption "Geekbench";
      iterm2.enable = lib.mkEnableOption "iTerm2";
      nvidia-geforce-now.enable = lib.mkEnableOption "NVIDIA GeForce NOW";
      outlook.enable = lib.mkEnableOption "Microsoft Outlook";
      spotify.enable = lib.mkEnableOption "Spotify";
      telegram.enable = lib.mkEnableOption "Telegram";
      vscode.enable = lib.mkEnableOption "Visual Studio Code";
      zed.enable = lib.mkEnableOption "Zed editor";
    };

    toolsets = {
      base.enable = lib.mkEnableOption "base CLI tools";
      dev.enable = lib.mkEnableOption "developer language toolchains";
      diagnostics.enable = lib.mkEnableOption "diagnostic and benchmark tools";
      network.enable = lib.mkEnableOption "network and transfer tools";
    };
  };
}
