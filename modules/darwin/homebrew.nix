{
  config,
  lib,
  ...
}:
let
  apps = config.my.apps;
  brews = config.my.brews;
  trustedTaps =
    lib.optionals apps.codexbar.enable [ "steipete/tap" ]
    ++ lib.optionals apps.engram.enable [ "gentleman-programming/tap" ]
    ++ lib.optionals brews.depot.enable [ "depot/tap" ];
in
{
  environment.variables = {
    HOMEBREW_NO_ANALYTICS = "1";
    HOMEBREW_NO_EMOJI = "1";
  };

  homebrew = {
    enable = true;
    caskArgs = {
      appdir = "/Applications";
    };
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = false;
      extraEnv = {
        HOMEBREW_NO_ANALYTICS = "1";
        HOMEBREW_NO_EMOJI = "1";
      };
    };
  };

  system.activationScripts.homebrew.text = lib.mkBefore (
    lib.optionalString (trustedTaps != [ ]) ''
      if [ -f "${config.homebrew.prefix}/bin/brew" ]; then
        echo >&2 "trusting configured Homebrew taps..."
        sudo \
          --user=${lib.escapeShellArg config.homebrew.user} \
          --set-home \
          "${config.homebrew.prefix}/bin/brew" trust --tap ${lib.escapeShellArgs trustedTaps}
      fi
    ''
  );
}
