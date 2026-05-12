{
  config,
  lib,
  pkgs,
  ...
}:
let
  defaultP10kConfig = ./p10k.zsh;
in
{
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    syntaxHighlighting.enable = true;

    history = {
      path = "$HOME/.zsh_history";
      save = 100000;
      size = 100000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        local p10k_instant_prompt="''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        [[ -r "$p10k_instant_prompt" ]] && source "$p10k_instant_prompt"
      '')
      (lib.mkOrder 1000 ''
        export EDITOR="${config.home.sessionVariables.EDITOR}"
        export VISUAL="${config.home.sessionVariables.VISUAL}"
        export PAGER="less -R"

        if [[ -r "$HOME/.1p-env" ]]; then
          set -o allexport
          source "$HOME/.1p-env"
          set +o allexport
        fi

        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

        if command -v zoxide >/dev/null 2>&1; then
          alias cd=z
        fi
      '')
    ];
  };

  home.activation.ensureWritableP10kConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    p10k_config="${config.home.homeDirectory}/.p10k.zsh"
    p10k_target=""

    if [ -L "$p10k_config" ]; then
      p10k_target="$(/usr/bin/readlink "$p10k_config")"
      case "$p10k_target" in
        /nix/store/*) /bin/rm "$p10k_config" ;;
      esac
    fi

    if [ ! -e "$p10k_config" ]; then
      /usr/bin/install -m 0644 ${defaultP10kConfig} "$p10k_config"
    elif [ ! -w "$p10k_config" ]; then
      /bin/chmod u+w "$p10k_config" || true
    fi
  '';
}
