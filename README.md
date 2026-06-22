# nix-setup

Personal, multi-host Nix configuration for macOS today and NixOS/Linux later.

Credits and thanks:

- [NixOS / nixpkgs](https://github.com/NixOS/nixpkgs), [nix-darwin](https://github.com/nix-darwin/nix-darwin), [Home Manager](https://github.com/nix-community/home-manager), and [flake-parts](https://github.com/hercules-ci/flake-parts) for the ecosystem this is built on.
- [Harsh Shandilya / msfjarvis dotfiles](https://github.com/msfjarvis/dotfiles) for the host/module separation inspiration.

This repo is intentionally opinionated, but it is structured so personal, work,
and future Linux hosts can share common layers without copy-pasting whole
machine configs.

Most of this repository was generated and iterated with AI assistance, then
reviewed, applied, and verified on the target machine. Treat it as a working
personal config rather than hand-written reference material.

## Overview

- `nixpkgs` tracks `nixpkgs-unstable`.
- `flake-parts` wires outputs.
- `nix-darwin` manages macOS system state.
- Home Manager owns user shell, CLI tools, language toolchains, aliases, and dotfiles.
- Fast-moving AI agent CLIs come from [numtide/llm-agents.nix](https://github.com/numtide/llm-agents.nix) and its binary cache.
- Homebrew casks are used for macOS GUI apps to avoid slow local builds and App Management friction.
- Host-specific removals are handled through feature flags, not list surgery.

## Hosts

Darwin hosts are declared in [lib/hosts.nix](./lib/hosts.nix):

- `deathbox-air`: current MacBook Air
- `deathbox-mini`: personal Mac mini; inherits common Darwin apps
- `shbam-work`: work MacBook; inherits common Darwin apps but disables social apps
- `work-macbook`: work MacBook; inherits common Darwin apps but disables Telegram

NixOS support is scaffolded with `mkNixosHost` and
[modules/nixos/common](./modules/nixos/common), but no Linux host is enabled yet.

## Layout

```text
flake.nix                         flake-parts entry point
lib/hosts.nix                     host inventory and mkDarwinHost/mkNixosHost
modules/common/options.nix        shared my.* feature flags
modules/darwin/common/            Darwin common system layer
modules/darwin/apps/casks.nix     Homebrew casks from my.apps.* flags
modules/nixos/common/             future NixOS common system layer
home/common/                      shared Home Manager config
home/darwin/                      macOS-only Home Manager config
home/linux/                       future Linux-only Home Manager config
home/users/smartass08/            user-level Home Manager base
hosts/darwin/<host>/              host-specific system and home overrides
scripts/                          bootstrap, check, switch, update, cleanup, doctor
```

## Bootstrap

On a fresh macOS host:

```sh
./scripts/bootstrap-nix.sh
```

The bootstrap script installs multi-user Nix when `nix` is missing, installs Homebrew when
`brew` is missing, locks the flake, and switches the active host.

After bootstrap:

```sh
./scripts/check.sh
./scripts/switch.sh
```

Scripts default to `hostname -s`. Override when checking another host:

```sh
NIX_SETUP_HOST=deathbox-mini ./scripts/check.sh
NIX_SETUP_HOST=shbam-work ./scripts/check.sh
NIX_SETUP_HOST=work-macbook ./scripts/check.sh
```

## Managed Pieces

- Zsh login shell with Powerlevel10k
- Writable `~/.p10k.zsh` seeded from [home/common/p10k.zsh](./home/common/p10k.zsh)
- iTerm2 dynamic profile using the Powerlevel10k MesloLGS NF font
- macOS text-caret repeat and tap-to-click trackpad settings
- Shared CLI tools and aliases
- Python, Node.js, Go, and Rust/Cargo toolchains from Nix
- Darwin defaults, fonts, Nix daemon settings, and Homebrew casks

## Feature Flags

Shared options live in [modules/common/options.nix](./modules/common/options.nix).

Darwin common enables GUI apps with `lib.mkDefault`, which lets hosts remove an
app cleanly:

```nix
{
  my.apps.telegram.enable = false;
}
```

That pattern is used by [hosts/darwin/work-macbook/default.nix](./hosts/darwin/work-macbook/default.nix).

Current Darwin app flags:

- `my.apps.codexbar.enable`
- `my.apps.discord.enable`
- `my.apps.epson-v39ii-driver.enable`
- `my.apps.focusrite.enable`
- `my.apps.geekbench.enable`
- `my.apps.iterm2.enable`
- `my.apps.jetbrains-toolbox.enable`
- `my.apps.krisp.enable`
- `my.apps.nvidia-geforce-now.enable`
- `my.apps.outlook.enable`
- `my.apps.spotify.enable`
- `my.apps.telegram.enable`
- `my.apps.whatsapp.enable`
- `my.apps.vscode.enable`
- `my.apps.zed.enable`

When `my.apps.epson-v39ii-driver.enable` is enabled, the system provides
`install-epson-v39ii-driver` and `uninstall-epson-v39ii-driver` helper commands.

Current Home Manager toolset flags:

- `my.toolsets.base.enable`
- `my.toolsets.dev.enable`
- `my.toolsets.diagnostics.enable`
- `my.toolsets.network.enable`

## Adding Things

Add a user CLI package in [home/common/cli.nix](./home/common/cli.nix), ideally
inside the right `my.toolsets.*` group.

Add a Darwin GUI app by:

1. Adding `my.apps.<name>.enable` in [modules/common/options.nix](./modules/common/options.nix).
2. Setting its default in [modules/darwin/common/default.nix](./modules/darwin/common/default.nix).
3. Mapping it to a cask in [modules/darwin/apps/casks.nix](./modules/darwin/apps/casks.nix).
4. Overriding the flag in a host module if a specific machine should not get it.

Add a host by creating `hosts/darwin/<host>/default.nix`,
`hosts/darwin/<host>/home.nix`, and an entry in [lib/hosts.nix](./lib/hosts.nix).

## Scripts

- `./scripts/check.sh`: run `nix flake check --all-systems` and build `$NIX_SETUP_HOST`.
- `./scripts/switch.sh`: apply `$NIX_SETUP_HOST`.
- `./scripts/update.sh`: update `flake.lock`, check, and build. Add `--switch` to apply.
- `./scripts/cleanup.sh [age]`: collect old Nix generations older than `age`; defaults to `14d`.
- `./scripts/doctor.sh`: print host settings, P10k status, important command paths, and managed cask versions.

## Verification

```sh
./scripts/check.sh
./scripts/doctor.sh
defaults read NSGlobalDomain InitialKeyRepeat
defaults read NSGlobalDomain KeyRepeat
zsh -ic 'alias cat; alias batch; command -v python3 pip3 node npm go cargo rustc'
```

To compare app inheritance:

```sh
for host in deathbox-air deathbox-mini shbam-work work-macbook; do
  echo "== $host"
  nix eval --json ".#darwinConfigurations.${host}.config.homebrew.casks" \
    | jq -r '.[] | if type == "string" then . else .name end'
done
```

## Notes

Opening a new iTerm2 window may be required after a switch so iTerm2 reloads the
dynamic profile and fonts.

This is a personal system config, not a universal starter template. Borrow the
structure freely, but review hostnames, usernames, app choices, secrets, and
macOS defaults before applying it to another machine.
