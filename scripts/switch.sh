#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/lib.sh"

nix_setup_require_normal_user
cd "${NIX_SETUP_ROOT}"
nix_setup_darwin_switch "$@"
