{
  config,
  lib,
  pkgs,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  onePasswordAgent =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "${homeDir}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "${homeDir}/.1password/agent.sock";
  privateIdentityAgent = "${homeDir}/.ssh/1password/agent.sock";
  sshConfigInclude = "Include ~/.ssh/config.d/*.conf";
  toolsets = config.my.toolsets;
in
{
  home.file.".ssh/config.d/shbam-cloudflared.conf" = lib.mkIf toolsets.network.enable {
    text = ''
      Host ssh-*.shb.am ssh-*.raihan.in
        IdentityAgent ${privateIdentityAgent}
        ProxyCommand ${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h
    '';
  };

  home.activation.ensureSshConfigIncludesConfigD = lib.mkIf toolsets.network.enable (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      ssh_dir="${config.home.homeDirectory}/.ssh"
      ssh_config="$ssh_dir/config"
      include_line="${sshConfigInclude}"
      one_password_agent="${onePasswordAgent}"
      private_agent="${privateIdentityAgent}"

      ${pkgs.coreutils}/bin/install -d -m 0700 "$ssh_dir"
      ${pkgs.coreutils}/bin/install -d -m 0700 "$ssh_dir/1password"
      ${pkgs.coreutils}/bin/ln -snf "$one_password_agent" "$private_agent"

      if [ ! -e "$ssh_config" ]; then
        ${pkgs.coreutils}/bin/printf '%s\n' "$include_line" > "$ssh_config"
        ${pkgs.coreutils}/bin/chmod 0600 "$ssh_config"
      elif ! ${pkgs.gnugrep}/bin/grep -Fxq "$include_line" "$ssh_config"; then
        ssh_config_tmp="$ssh_config.hm-include-tmp"
        ${pkgs.coreutils}/bin/printf '%s\n\n' "$include_line" > "$ssh_config_tmp"
        ${pkgs.coreutils}/bin/cat "$ssh_config" >> "$ssh_config_tmp"
        ${pkgs.coreutils}/bin/chmod 0600 "$ssh_config_tmp"
        ${pkgs.coreutils}/bin/mv "$ssh_config_tmp" "$ssh_config"
      fi
    ''
  );
}
