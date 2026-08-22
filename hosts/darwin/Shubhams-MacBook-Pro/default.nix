{ lib, ... }:
{
  # MDM owns the hostname on this machine, so never let nix-darwin run
  # `scutil --set`. mkDarwinHost sets these from the host attribute name;
  # nix-darwin skips each scutil call when the option is null.
  networking = {
    computerName = lib.mkForce null;
    hostName = lib.mkForce null;
    localHostName = lib.mkForce null;
  };

  my.apps = {
    # Social apps are provisioned and policed by the company MDM. Slack in
    # particular must not be managed here even though it already defaults off.
    discord.enable = false;
    slack.enable = false;
    telegram.enable = false;
    whatsapp.enable = false;

    # Personal-use apps stay off a managed machine. Dropping amphetamine also
    # drops the /etc/sudoers.d/amphetamine_PowerProtect helper and the Mac App
    # Store sign-in it would otherwise need; dropping codexbar and engram
    # leaves homebrew.taps empty, so activation stops running `brew trust`.
    amphetamine.enable = false;
    claude.enable = false;
    codex.enable = false;
    codexbar.enable = false;
    engram.enable = false;
    geekbench.enable = false;
    iina.enable = false;
    kimi.enable = false;
    nvidia-geforce-now.enable = false;
    spotify.enable = false;

    # Editors and mail come from the company's own provisioning.
    jetbrains-toolbox.enable = false;
    outlook.enable = false;
    vscode.enable = false;
    zed.enable = false;
  };

  my.brews.rclone.enable = false;
}
