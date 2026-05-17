{ lib, username, ... }:
let
  currentHostTrackpadDefaults = {
    "com.apple.mouse.tapBehavior" = 1;
    "com.apple.trackpad.enableSecondaryClick" = 1;
    "com.apple.trackpad.fiveFingerPinchSwipeGesture" = 2;
    "com.apple.trackpad.fourFingerHorizSwipeGesture" = 2;
    "com.apple.trackpad.fourFingerPinchSwipeGesture" = 2;
    "com.apple.trackpad.fourFingerVertSwipeGesture" = 2;
    "com.apple.trackpad.momentumScroll" = 1;
    "com.apple.trackpad.pinchGesture" = 1;
    "com.apple.trackpad.rotateGesture" = 1;
    "com.apple.trackpad.scrollBehavior" = 2;
    "com.apple.trackpad.threeFingerDragGesture" = 0;
    "com.apple.trackpad.threeFingerHorizSwipeGesture" = 2;
    "com.apple.trackpad.threeFingerTapGesture" = 0;
    "com.apple.trackpad.threeFingerVertSwipeGesture" = 2;
    "com.apple.trackpad.twoFingerDoubleTapGesture" = 1;
    "com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture" = 3;
    "com.apple.trackpad.version" = 5;
  };

  currentHostTrackpadCommands =
    lib.concatStringsSep "\n"
      (lib.mapAttrsToList (
        key: value:
        "as_user defaults -currentHost write NSGlobalDomain ${lib.escapeShellArg key} -int ${toString value}"
      ) currentHostTrackpadDefaults);
in
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
      "com.apple.trackpad.forceClick" = true;
    };

    trackpad = {
      ActuateDetents = true;
      Clicking = true;
      DragLock = false;
      Dragging = false;
      FirstClickThreshold = 1;
      ForceSuppressed = false;
      SecondClickThreshold = 1;
      TrackpadCornerSecondaryClick = 0;
      TrackpadFourFingerHorizSwipeGesture = 2;
      TrackpadFourFingerPinchGesture = 2;
      TrackpadFourFingerVertSwipeGesture = 2;
      TrackpadMomentumScroll = true;
      TrackpadPinch = true;
      TrackpadRightClick = true;
      TrackpadRotate = true;
      TrackpadThreeFingerDrag = false;
      TrackpadThreeFingerHorizSwipeGesture = 2;
      TrackpadThreeFingerTapGesture = 0;
      TrackpadThreeFingerVertSwipeGesture = 2;
      TrackpadTwoFingerDoubleTapGesture = true;
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
    };

    dock = {
      autohide = true;
      magnification = true;
      largesize = 72;
      tilesize = 45;
    };

    CustomUserPreferences = {
      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadFiveFingerPinchGesture = 2;
        TrackpadHandResting = true;
        TrackpadHorizScroll = 1;
        TrackpadScroll = true;
        USBMouseStopsTrackpad = 0;
        UserPreferences = true;
        version = 12;
      };

      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        TrackpadFiveFingerPinchGesture = 2;
        TrackpadHandResting = true;
        TrackpadHorizScroll = 1;
        TrackpadScroll = true;
        USBMouseStopsTrackpad = 0;
        UserPreferences = true;
        version = 5;
      };
    };
  };

  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo >&2 "current-host trackpad defaults..."
    user=${lib.escapeShellArg username}
    as_user() {
      launchctl asuser "$(id -u -- "$user")" sudo --user="$user" -- "$@"
    }

    ${currentHostTrackpadCommands}
  '';
}
