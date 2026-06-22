{
  config,
  lib,
  pkgs,
  ...
}:
let
  installerUrl = "https://ftp.epson.com/drivers/V39II_Lite_64NR_AM.dmg";
  installerSha256 = "b6e4d1730ed6958082c15824d92bbf37cc52ab26c58d4788145dfcd9d7cd2c05";

  installEpsonV39iiDriver = pkgs.writeShellScriptBin "install-epson-v39ii-driver" ''
    set -euo pipefail

    installer_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/epson-v39ii-driver"
    dmg="$installer_dir/V39II_Lite_64NR_AM.dmg"
    tmp="$dmg.tmp"

    mkdir -p "$installer_dir"

    if [ ! -f "$dmg" ] || ! printf '%s  %s\n' '${installerSha256}' "$dmg" | /usr/bin/shasum -a 256 -c - >/dev/null 2>&1; then
      echo "Downloading Epson Perfection V39 II driver and utilities installer..."
      /usr/bin/curl --fail --location --output "$tmp" '${installerUrl}'

      actual_sha256="$(/usr/bin/shasum -a 256 "$tmp" | /usr/bin/awk '{ print $1 }')"
      if [ "$actual_sha256" != '${installerSha256}' ]; then
        rm -f "$tmp"
        echo "Checksum mismatch for Epson installer." >&2
        echo "Expected: ${installerSha256}" >&2
        echo "Actual:   $actual_sha256" >&2
        exit 1
      fi

      mv "$tmp" "$dmg"
    fi

    mount="$(
      /usr/bin/hdiutil attach -nobrowse -readonly "$dmg" \
        | /usr/bin/awk '/\/Volumes\// { sub(/^.*\/Volumes\\//, "/Volumes/"); print; exit }'
    )"

    if [ -z "$mount" ]; then
      echo "Could not determine mounted Epson installer volume." >&2
      exit 1
    fi

    cleanup() {
      /usr/bin/hdiutil detach "$mount" >/dev/null 2>&1 || true
    }
    trap cleanup EXIT

    echo "Opening Epson installer. Finish the GUI installer to install Epson ScanSmart, Epson Scan 2, and the scanner driver."
    /usr/bin/open -W "$mount/Epson Installer.app"
  '';

  uninstallEpsonV39iiDriver = pkgs.writeShellScriptBin "uninstall-epson-v39ii-driver" ''
        set -euo pipefail

        uninstaller="/Applications/Epson Software/Uninstaller.app"
        updater="/Applications/Epson Software/EPSON Software Updater.app"

        if [ -d "$uninstaller" ]; then
          cat <<'EOF'
    Opening Epson Uninstaller.

    In the Epson Uninstaller window, select the Epson ScanSmart / Epson Scan 2
    entries you want to remove, then click Uninstall.

    Note: Epson says this uninstaller removes all Epson scanner drivers from this
    Mac, so reinstall drivers for any other Epson scanners afterwards if needed.
    EOF
          /usr/bin/open -W "$uninstaller"
          exit 0
        fi

        if [ -d "$updater" ]; then
          cat <<'EOF'
    Epson Uninstaller is not installed yet.

    Opening EPSON Software Updater. Use it to download/install the Uninstaller
    utility, then run:

      uninstall-epson-v39ii-driver
    EOF
          /usr/bin/open -W "$updater"
          exit 0
        fi

        cat >&2 <<'EOF'
    Could not find Epson Uninstaller or EPSON Software Updater.

    Install Epson's V39 II software first with:

      install-epson-v39ii-driver

    Then use EPSON Software Updater to install the Uninstaller utility, or visit:

      https://epson.com/Support/Scanners/Perfection-Series/Epson-Perfection-V39-II/s/SPT_B11B268201
    EOF
        exit 1
  '';
in
{
  config = lib.mkIf config.my.apps.epson-v39ii-driver.enable {
    environment.systemPackages = [
      installEpsonV39iiDriver
      uninstallEpsonV39iiDriver
    ];
  };
}
