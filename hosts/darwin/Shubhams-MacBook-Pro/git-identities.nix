{
  config,
  lib,
  pkgs,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  onePasswordAgent = "${homeDir}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  agentLink = "${homeDir}/.ssh/1password/agent.sock";
  opSshSign = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

  # 1Password publishes each SSH key to the agent using the item title as the
  # key comment, so these must match the 1Password item titles byte for byte.
  mercorKeyTitle = "Mercor - Work";
  deeptuneKeyTitle = "Deeptune - Work";

  gitUserName = "Shubham Dubey";

  # Mercor is the global identity; Deeptune only applies under ~/deeptune.
  mercorEmail = "shubhamdubey@mercor.com";
  mercorSshCommand = "${homeDir}/.local/bin/git-mercor-ssh";

  deeptuneEmail = "shubham.dubey@deeptune.com";
  deeptuneScope = "${homeDir}/deeptune";
  deeptuneSshCommand = "${homeDir}/.local/bin/git-deeptune-ssh";

  git = "${pkgs.git}/bin/git";

  # With two GitHub identities in one agent, ssh offers keys in agent order and
  # the wrong account can win the handshake. Each wrapper pins exactly one key.
  mkSshWrapper = keyTitle: ''
    #!${pkgs.zsh}/bin/zsh
    set -euo pipefail

    /usr/bin/install -d -m 0700 '${homeDir}/.ssh/1password'
    /bin/ln -snf '${onePasswordAgent}' '${agentLink}'

    key="$(
      SSH_AUTH_SOCK='${agentLink}' ${pkgs.openssh}/bin/ssh-add -L 2>/dev/null \
        | /usr/bin/awk '/ ${keyTitle}$/ { print; exit }' || true
    )"

    if [ -z "$key" ]; then
      echo "error: 1Password agent has no SSH key titled '${keyTitle}'" >&2
      echo "unlock 1Password and confirm the item title matches exactly" >&2
      exit 1
    fi

    exec ${pkgs.openssh}/bin/ssh \
      -i =(printf '%s\n' "$key") \
      -o IdentitiesOnly=yes \
      -o IdentityAgent='${agentLink}' \
      "$@"
  '';

  # ssh-add exits non-zero when the agent is missing or locked, and Home
  # Manager runs activation under `set -e`, so every lookup must tolerate it.
  lookupKey = keyTitle: ''
    SSH_AUTH_SOCK='${agentLink}' ${pkgs.openssh}/bin/ssh-add -L 2>/dev/null \
      | /usr/bin/awk '/ ${keyTitle}$/ { print; exit }' || true
  '';
in
{
  home.file.".local/bin/git-mercor-ssh" = {
    executable = true;
    force = true;
    text = mkSshWrapper mercorKeyTitle;
  };

  home.file.".local/bin/git-deeptune-ssh" = {
    executable = true;
    force = true;
    text = mkSshWrapper deeptuneKeyTitle;
  };

  home.activation.gitIdentities = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD /usr/bin/install -d -m 0700 '${homeDir}/.ssh/1password'
    $DRY_RUN_CMD /bin/ln -snf '${onePasswordAgent}' '${agentLink}'

    mercor_key="$(${lookupKey mercorKeyTitle})"
    deeptune_key="$(${lookupKey deeptuneKeyTitle})"

    # Global identity: Mercor.
    $DRY_RUN_CMD ${git} config --global --replace-all user.name '${gitUserName}'
    $DRY_RUN_CMD ${git} config --global --replace-all user.email '${mercorEmail}'
    $DRY_RUN_CMD ${git} config --global --replace-all core.sshCommand '${mercorSshCommand}'
    $DRY_RUN_CMD ${git} config --global --replace-all gpg.format ssh
    $DRY_RUN_CMD ${git} config --global --replace-all gpg.ssh.program '${opSshSign}'
    $DRY_RUN_CMD ${git} config --global --replace-all 'url.git@github.com:.insteadOf' 'https://github.com/'

    # Signing stays off until the key is actually available, otherwise every
    # commit fails instead of just being unsigned.
    if [ -z "$mercor_key" ]; then
      warnEcho "1Password agent has no SSH key titled '${mercorKeyTitle}'."
      warnEcho "Commit signing disabled; unlock 1Password and switch again."
      $DRY_RUN_CMD ${git} config --global --replace-all commit.gpgsign false
    else
      $DRY_RUN_CMD ${git} config --global --replace-all user.signingkey "$mercor_key"
      $DRY_RUN_CMD ${git} config --global --replace-all commit.gpgsign true
    fi

    # Scoped identity: Deeptune, under ~/deeptune only.
    if [ -z "$deeptune_key" ]; then
      warnEcho "1Password agent has no SSH key titled '${deeptuneKeyTitle}'."
      warnEcho "Skipped ~/.gitconfig-deeptune; unlock 1Password and switch again."
    else
      $DRY_RUN_CMD /usr/bin/install -m 0600 /dev/null '${homeDir}/.gitconfig-deeptune'
      $DRY_RUN_CMD /bin/sh -c "printf '%s\n' '[user]' '  email = ${deeptuneEmail}' '  signingkey = $deeptune_key' '[core]' '  sshCommand = ${deeptuneSshCommand}' > '${homeDir}/.gitconfig-deeptune'"
      $DRY_RUN_CMD ${git} config --global --replace-all 'includeIf.gitdir:${deeptuneScope}/.path' '${homeDir}/.gitconfig-deeptune'
    fi
  '';
}
