#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/lib.sh"

older_than="${1:-14d}"

cd "${NIX_SETUP_ROOT}"
nix_setup_require_nix

nix-collect-garbage --delete-older-than "${older_than}"
nix store optimise
