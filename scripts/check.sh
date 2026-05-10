#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/lib.sh"

cd "${NIX_SETUP_ROOT}"
nix_setup_require_nix

nix flake check
nix_setup_darwin_rebuild build
