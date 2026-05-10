# deathbox-air Nix setup

Flake-based macOS setup for `smartass08` on Apple Silicon. It follows the same broad separation as `msfjarvis/dotfiles`: host configuration, Darwin modules, and Home Manager modules.

## Bootstrap

This machine currently needs Nix before `darwin-rebuild` can run. The bootstrap script installs Lix when `nix` is missing, installs Homebrew when `brew` is missing, then switches to this flake:

```sh
./scripts/bootstrap-lix.sh
```

If a previous installer run was interrupted after creating `/nix`, rerun the same script. It only proceeds once the `nix` binary is actually available.

After the first switch, use:

```sh
./scripts/switch.sh
```

The flake pins `nixpkgs` to `nixpkgs-unstable`, and nix-darwin publishes that same input as the default `nixpkgs` registry and legacy `NIX_PATH` entry.

## What Is Managed

- Hostname: `deathbox-air`
- User: `smartass08`
- System: `aarch64-darwin`
- Zsh login shell with Powerlevel10k
- iTerm2 dynamic profile using the Powerlevel10k MesloLGS NF font
- macOS key repeat tuned for faster text-caret movement
- Shared CLI tools and aliases through Home Manager
- Darwin host settings for shell, fonts, defaults, and app/profile links
- Homebrew casks for GUI apps

## Package Ownership

Personal command-line tools belong in `modules/home/cli.nix`. This keeps the
CLI set reusable for a future Linux host and avoids duplicating packages in
Darwin `environment.systemPackages`.

Darwin modules should stay focused on host behavior: shell registration, macOS
defaults, fonts, hostname, Nix daemon settings, and GUI apps. GUI apps belong in
`modules/darwin/homebrew.nix`.

## App Fallbacks

The requested CLI tools are installed from Nix packages through Home Manager:

- `pkgs.claude-code`

GUI apps are managed as casks:

- `discord`
- `iterm2`
- `microsoft-outlook`
- `spotify`
- `telegram`
- `visual-studio-code`
- `zed`

If another GUI app is added later, prefer adding it to `modules/darwin/homebrew.nix` unless there is a specific reason to keep it in Nix.

## Checks

```sh
./scripts/check.sh
./scripts/switch.sh
defaults read NSGlobalDomain InitialKeyRepeat
defaults read NSGlobalDomain KeyRepeat
test -w ~/.p10k.zsh && p10k help >/dev/null
zsh -ic 'alias cat; alias batch; command -v bat aria2c rclone claude git nh nom ssh code zed'
brew list --cask --versions discord iterm2 microsoft-outlook spotify telegram visual-studio-code zed
```

## Automation Scripts

- `./scripts/check.sh`: run `nix flake check` and build `deathbox-air`.
- `./scripts/switch.sh`: apply the current flake generation.
- `./scripts/update.sh`: update `flake.lock`, check, and build. Add `--switch`
  to apply after a successful build.
- `./scripts/cleanup.sh [age]`: collect old Nix generations older than `age`;
  defaults to `14d`.
- `./scripts/doctor.sh`: print the hostname, key-repeat setting, P10k status,
  important CLI command paths, and managed Homebrew cask versions.

After switching, open a new iTerm2 window. If prompt glyphs still look wrong in an
already-open session, restart iTerm2 so it reloads the dynamic profile and fonts.
