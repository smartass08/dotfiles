{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aria2
    bat
    claude-code
    coreutils
    curl
    fd
    fzf
    fastfetch
    git
    jq
    nh
    nix-output-monitor
    nixfmt
    openssh
    rclone
    ripgrep
    sd
    shellcheck
    shfmt
    tree
    unzip
    zip
  ];

  home.shellAliases = {
    batch = "aria2c --conditional-get true --continue true --auto-file-renaming=false --input-file";
    cat = "bat --style=grid,header";
    gi = "git";
    today = "date +%F";
  };

  programs.bat = {
    enable = true;
    config = {
      style = "grid,header";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };
  programs.zoxide.enable = true;
}
