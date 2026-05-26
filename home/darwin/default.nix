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
    '';
  };
}
