{ ... }:
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
    casks = [
      # GUI apps live in Homebrew to avoid local source builds and App Management friction.
      "discord"
      "iterm2"
      "microsoft-outlook"
      "spotify"
      "telegram"
      "visual-studio-code"
      "zed"
    ];
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
}
