{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  apps = config.my.apps;
  userHome = config.users.users.${username}.home;

  powerProtectAppleScript = pkgs.writeText "amphetamine-power-protect.applescript" ''
    on enableDisablePowerProtect(inputString)
      if not powerProtectSudoFileExists() then
        return "success"
      end if

      if inputString is "enable" then
        try
          «event sysoexec» "sudo pmset -a disablesleep 1"
          return "success"
        on error
          return "fail"
        end try
      else if inputString is "disable" then
        set pmsetResult to «event sysoexec» "pmset -g | awk '/SleepDisabled/{print $2}'"

        if pmsetResult contains "1" then
          try
            «event sysoexec» "sudo pmset -a disablesleep 0"
            return "success"
          on error
            return "fail"
          end try
        end if

        return "success"
      end if

      return "fail"
    end enableDisablePowerProtect

    on installPowerProtectSudoOverride(inputString)
      return "success"
    end installPowerProtectSudoOverride

    on powerProtectSudoFileExists()
      tell application "System Events"
        if exists file "/etc/sudoers.d/amphetamine_PowerProtect" then
          return true
        else
          return false
        end if
      end tell
    end powerProtectSudoFileExists
  '';

  sudoersFile = pkgs.writeText "amphetamine_PowerProtect" ''
    Cmnd_Alias PMSET_AMPHETAMINE= /usr/bin/pmset -a disablesleep 1, /usr/bin/pmset -a disablesleep 0
    %admin ALL=(ALL) NOPASSWD: PMSET_AMPHETAMINE
  '';
in
lib.mkIf apps.amphetamine.enable {
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo >&2 "installing Amphetamine Power Protect helper..."
    user=${lib.escapeShellArg username}
    user_home=${lib.escapeShellArg userHome}

    as_user() {
      launchctl asuser "$(id -u -- "$user")" sudo --user="$user" -- "$@"
    }

    script_dir="$user_home/Library/Application Scripts/com.if.Amphetamine"
    script_target="$script_dir/powerProtect.scpt"
    script_tmp="$script_target.tmp"

    as_user /bin/mkdir -p "$script_dir"
    as_user /usr/bin/osacompile -o "$script_tmp" ${powerProtectAppleScript}
    as_user /bin/chmod 0644 "$script_tmp"
    as_user /bin/mv -f "$script_tmp" "$script_target"

    sudoers_target="/private/etc/sudoers.d/amphetamine_PowerProtect"
    sudoers_tmp="$sudoers_target.tmp"

    ${pkgs.coreutils}/bin/install -d -m 0755 /private/etc/sudoers.d
    ${pkgs.coreutils}/bin/install -m 0440 ${sudoersFile} "$sudoers_tmp"
    /usr/sbin/chown root:wheel "$sudoers_tmp"
    /usr/sbin/visudo -cf "$sudoers_tmp"
    ${pkgs.coreutils}/bin/mv -f "$sudoers_tmp" "$sudoers_target"
    ${pkgs.coreutils}/bin/chmod 0440 "$sudoers_target"
  '';
}
