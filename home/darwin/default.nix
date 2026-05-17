{
  imports = [
    ./iterm2.nix
  ];

  programs.zsh.profileExtra = ''
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  '';
}
