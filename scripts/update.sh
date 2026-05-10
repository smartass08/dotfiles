#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/lib.sh"

usage() {
  cat <<'EOF'
Usage: ./scripts/update.sh [options] [flake-input ...]

Updates flake inputs, runs checks, and builds the Darwin configuration.

Options:
  --switch     Apply the new generation after the build passes.
  --no-build   Only update flake.lock and run nix flake check.
  -h, --help   Show this help.

Examples:
  ./scripts/update.sh
  ./scripts/update.sh nixpkgs home-manager
  ./scripts/update.sh --switch
EOF
}

do_build=1
do_switch=0
flake_inputs=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --switch)
      do_switch=1
      shift
      ;;
    --no-build)
      do_build=0
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    --)
      shift
      flake_inputs+=("$@")
      break
      ;;
    *)
      flake_inputs+=("$1")
      shift
      ;;
  esac
done

nix_setup_require_normal_user
cd "${NIX_SETUP_ROOT}"
nix_setup_require_nix

if [ "${#flake_inputs[@]}" -eq 0 ]; then
  nix flake update
else
  nix flake update "${flake_inputs[@]}"
fi

nix flake check

if [ "${do_build}" -eq 1 ]; then
  nix_setup_darwin_rebuild build
fi

if [ "${do_switch}" -eq 1 ]; then
  nix_setup_darwin_switch "$@"
fi
