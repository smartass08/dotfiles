{ lib, ... }:
{
  imports = [
    ./iterm2.nix
  ];

  home.file.".nvm/.keep".text = "";

  programs.zsh = {
    profileExtra = ''
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';

    initContent = lib.mkAfter ''
      export NVM_DIR="$HOME/.nvm"
      if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
        source "/opt/homebrew/opt/nvm/nvm.sh"
      elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
        source "$NVM_DIR/nvm.sh"
      fi

      keychain-status() {
        local keychain="''${1:-$HOME/Library/Keychains/login.keychain-db}"

        if /usr/bin/security show-keychain-info "$keychain" >/dev/null 2>&1; then
          printf 'unlocked: %s\n' "$keychain"
        else
          printf 'locked: %s\n' "$keychain"
          return 1
        fi
      }

      unlock-keychain() {
        local keychain="''${1:-$HOME/Library/Keychains/login.keychain-db}"

        if keychain-status "$keychain" >/dev/null 2>&1; then
          printf 'already unlocked: %s\n' "$keychain"
          return 0
        fi

        /usr/bin/security unlock-keychain "$keychain"
      }
    '';
  };
}
