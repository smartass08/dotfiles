{
  config,
  lib,
  pkgs,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  onePasswordAgent = "${homeDir}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  home.activation.gitPersonalInclude = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    available_keys="$(
      SSH_AUTH_SOCK="${onePasswordAgent}" ${pkgs.openssh}/bin/ssh-add -L 2>/dev/null
    )"

    personal_key="$(
      printf '%s\n' "$available_keys" | /usr/bin/awk '/ me - personal$/ { print; exit }'
    )"

    if [ -z "$personal_key" ]; then
      personal_key="$(
        printf '%s\n' "$available_keys" | /usr/bin/awk '/ me - private$/ { print; exit }'
      )"
    fi

    if [ -z "$personal_key" ]; then
      echo "error: no personal 1Password SSH key available from the agent" >&2
      echo "expected a key ending with 'me - personal' or 'me - private'" >&2
      exit 1
    fi

    $DRY_RUN_CMD /usr/bin/install -m 0600 /dev/null '${homeDir}/.gitconfig-personal'
    $DRY_RUN_CMD /bin/sh -c "printf '%s\n' '[user]' '  email = me@shb.am' '  signingkey = $personal_key' > '${homeDir}/.gitconfig-personal'"
    $DRY_RUN_CMD ${pkgs.git}/bin/git config --global --replace-all 'includeIf.gitdir:${homeDir}/personal/.path' '${homeDir}/.gitconfig-personal'
  '';
}
