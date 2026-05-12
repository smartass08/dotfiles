#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/lib.sh"

cd "${NIX_SETUP_ROOT}"
nix_setup_require_nix
nix_setup_load_homebrew

echo "host: $(hostname -s)"
echo "flake: ${NIX_SETUP_HOST}"
defaults read NSGlobalDomain InitialKeyRepeat 2>/dev/null | sed 's/^/InitialKeyRepeat: /'
defaults read NSGlobalDomain KeyRepeat 2>/dev/null | sed 's/^/KeyRepeat: /'
test -w "${HOME}/.p10k.zsh" && echo "p10k: writable"

for command_name in aria2c bat cargo claude git go jq nh node nom npm npx pip pip3 python python3 rclone rg rust-analyzer rustc rustfmt ssh virtualenv zsh; do
  command -v "${command_name}"
done

if command -v brew >/dev/null 2>&1; then
  mapfile -t casks < <(nix eval --json ".#darwinConfigurations.${NIX_SETUP_HOST}.config.homebrew.casks" | jq -r '.[] | if type == "string" then . else .name end')
  if [ "${#casks[@]}" -gt 0 ]; then
    brew list --cask --versions "${casks[@]}"
  fi
else
  echo "brew: not found" >&2
fi
