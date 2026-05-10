#!/usr/bin/env bash
# Shared helpers for repository scripts. Source this file from bash scripts.

NIX_SETUP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
NIX_SETUP_HOST="${NIX_SETUP_HOST:-deathbox-air}"

nix_setup_load_nix() {
  if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    local restore_nounset=0
    case "$-" in
      *u*)
        restore_nounset=1
        set +u
        ;;
    esac

    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

    if [ "$restore_nounset" -eq 1 ]; then
      set -u
    fi
  fi

  if ! command -v nix >/dev/null 2>&1 && [ -x /nix/var/nix/profiles/default/bin/nix ]; then
    export PATH="/nix/var/nix/profiles/default/bin:${PATH}"
  fi

  export NIX_CONFIG="${NIX_CONFIG-}
experimental-features = nix-command flakes
"
}

nix_setup_load_homebrew() {
  if ! command -v brew >/dev/null 2>&1 && [ -x /opt/homebrew/bin/brew ]; then
    export PATH="/opt/homebrew/bin:${PATH}"
  fi
}

nix_setup_require_nix() {
  nix_setup_load_nix

  if ! command -v nix >/dev/null 2>&1; then
    echo "nix is not available. Run ./scripts/bootstrap-lix.sh first." >&2
    exit 1
  fi
}

nix_setup_require_normal_user() {
  if [ "${EUID}" -eq 0 ]; then
    echo "Run this script as your normal user; it will call sudo only when needed." >&2
    exit 1
  fi
}

nix_setup_darwin_rebuild() {
  local action="$1"
  shift

  nix_setup_require_nix
  nix run "${NIX_SETUP_ROOT}#darwin-rebuild" -- "${action}" --flake "${NIX_SETUP_ROOT}#${NIX_SETUP_HOST}" "$@"
}

nix_setup_darwin_switch() {
  nix_setup_require_nix
  sudo -v
  sudo env HOME=/var/root NIX_CONFIG="${NIX_CONFIG}" "$(command -v nix)" run "${NIX_SETUP_ROOT}#darwin-rebuild" -- switch --flake "${NIX_SETUP_ROOT}#${NIX_SETUP_HOST}" "$@"
}
