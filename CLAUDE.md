# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix-based dotfiles repository for macOS (aarch64-darwin). It uses:
- **nix-darwin**: System-level macOS configuration
- **home-manager**: User environment and dotfiles management
- **Homebrew**: GUI apps and CLI tools not in nixpkgs or needing newer versions

## Commands

All commands use [go-task](https://taskfile.dev/) via `task`:

```bash
task update-all           # Update brew, nix flakes, darwin, and home-manager
task rebuild-darwin       # Apply nix-darwin config (runs update-flakes first)
task update-home-manager  # Apply home-manager config
task clean-all            # Run brew cleanup and nix garbage collection
```

Manual equivalents:
```bash
nix flake update                      # Update flake.lock
sudo darwin-rebuild switch --flake .  # Apply nix-darwin
home-manager switch --flake .         # Apply home-manager
```

## Architecture

**flake.nix** - Entry point defining:
- `darwinConfigurations.fourteen` - nix-darwin system config
- `homeConfigurations.context` - home-manager user config

**nix-darwin/configuration.nix** - System-wide settings:
- Homebrew casks (GUI apps)
- TouchID for sudo
- Passwordless sudo for specific commands

**home.nix** - Imports all home-manager modules from `home-manager/`:
- `terminal.nix` - alacritty, tmux, zsh, bat, eza
- `neovim.nix` - Neovim via nixvim
- `git.nix` - Git and GitHub CLI configuration
- `development.nix` - Dev tools (mise, rustup, ripgrep, etc.)
- `cloud.nix`, `encryption.nix`, `macos.nix`, `nix.nix`, `common.nix`

**hosts/fourteen/** - Host-specific overrides:
- `darwin.nix` - Additional Homebrew packages for this machine
- `home.nix` - User-specific packages, git signing, shell init

## Key Patterns

- Nix manages all CLI tools and dotfiles; Homebrew handles GUI apps
- Host-specific configs in `hosts/<hostname>/` override base configs
- The `rebuild-darwin` task has a precondition to prevent building packages from source (ensures binary cache hits)
