# Repository Guidelines

## Project Structure & Module Organization

This repository defines a personal macOS environment with Nix, nix-darwin, Home Manager, and Homebrew. `flake.nix` is the main entry point; `home.nix` assembles the user configuration. Put reusable user modules in `home-manager/`, system-wide settings in `nix-darwin/`, and machine-specific overrides in `hosts/<hostname>/` (currently `hosts/maxine/`). Static files managed by Home Manager belong in `home-manager/files/`. Operational scripts live in `scripts/`; migration procedures are documented in `MIGRATION.md`.

## Build, Test, and Development Commands

- `nix flake check`: evaluate the flake and catch configuration errors.
- `darwin-rebuild build --flake .`: build the macOS system configuration without activating it.
- `home-manager build --flake .`: build the user configuration without switching profiles.
- `task rebuild-darwin`: update flake inputs and apply nix-darwin after its binary-cache precheck.
- `task update-home-manager`: update inputs and apply the Home Manager configuration.
- `task backup-src -- --dry-run`: preview the source backup without creating an archive.

Use `task --list` to see maintenance commands. Treat `switch`, update, cleanup, and non-dry-run backup tasks as state-changing operations.

## Coding Style & Naming Conventions

Format Nix files with `nixfmt` and follow its two-space indentation. Keep modules declarative and group related options in attribute sets. Use lowercase, descriptive filenames such as `development.nix`; use hyphenated names for static assets and shell scripts. Shell scripts should use Bash strict mode where appropriate, pass `shellcheck`, and quote variable expansions.

## Testing Guidelines

There is no dedicated test suite or coverage threshold. Before submitting Nix changes, run `nix flake check` and build each affected configuration. For backup-script changes, run its `--dry-run` path against representative files and confirm exclusions. Do not activate system changes merely to validate syntax.

## Commit & Pull Request Guidelines

History favors short, imperative, mostly lowercase subjects, for example `add shortcuts` or `update flakes`. Keep each commit focused. Pull requests should explain the motivation, identify affected system or Home Manager modules, and list validation commands. Link relevant issues when available; include screenshots only for visible terminal or application changes.

## Security & Configuration Tips

Never commit plaintext credentials, private keys, or host secrets. Preserve the repository's `git-crypt` and `.recipients` workflow for encrypted material under `secrets/`, and review staged diffs before committing.
