#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

# shellcheck source=scripts/lib.sh
. "${repo_dir}/scripts/lib.sh"

if [ "${EUID}" -eq 0 ]; then
  echo "Run this script as your normal user; it uses sudo only for nix-darwin activation." >&2
  exit 1
fi

nix_setup_load_nix

if ! command -v nix >/dev/null 2>&1; then
  curl -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
  nix_setup_load_nix
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "nix is still not available after the Lix installer finished." >&2
  exit 1
fi

nix_setup_load_homebrew

if ! command -v brew >/dev/null 2>&1; then
  sudo -v
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/opt/homebrew/bin:${PATH}"
fi

nix flake lock "${repo_dir}"
nix_setup_darwin_switch "$@"
