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
