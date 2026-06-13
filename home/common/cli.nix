{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  packages = config.my.pkgs;
  toolsets = config.my.toolsets;
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages =
    with pkgs;
    lib.optionals toolsets.base.enable [
      bat
      coreutils
      curl
      fd
      fastfetch
      fzf
      gh
      git
      jq
      nano
      nh
      nix-output-monitor
      nixfmt
      ripgrep
      sd
      shellcheck
      shfmt
      tree
      unzip
      zip
    ]
    ++ lib.optionals toolsets.dev.enable [
      cargo
      llmAgents.claude-code
      llmAgents.opencode
      llmAgents.codex
      go
      nodejs_latest
      python3
      python3Packages.pip
      python3Packages.virtualenv
      rust-analyzer
      rustc
      rustfmt
    ]
    ++ lib.optionals toolsets.diagnostics.enable [
      ookla-speedtest
    ]
    ++ lib.optionals toolsets.network.enable [
      aria2
      openssh
    ]
    ++ lib.optionals packages.awscli2.enable [
      awscli2
    ]
    ++ lib.optionals (toolsets.network.enable && !pkgs.stdenv.hostPlatform.isDarwin) [
      rclone
    ];

  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
  };

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

  xdg.configFile."direnv/direnv.toml".text = ''
    [global]
    hide_env_diff = true
  '';

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zoxide.enable = true;
}
