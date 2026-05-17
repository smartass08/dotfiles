{ lib, username, ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      # Controls text-caret movement when holding arrow keys. Keep the initial
      # delay moderate so normal typing does not accidentally repeat keys.
      InitialKeyRepeat = 15;
      KeyRepeat = 2;

      # Enables tap-to-click in the global domain, including places that do not
      # read the per-device trackpad defaults.
      "com.apple.mouse.tapBehavior" = 1;
    };

    trackpad = {
      Clicking = true;
    };

    dock = {
      autohide = true;
      magnification = true;
      largesize = 72;
      tilesize = 45;
    };
  };

  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo >&2 "current-host trackpad defaults..."
    user=${lib.escapeShellArg username}
    launchctl asuser "$(id -u -- "$user")" sudo --user="$user" -- \
      defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  '';
}
