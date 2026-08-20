# Laptop Migration & Backup Checklist

This document details all directories and files to back up before wiping the current laptop, an audit of installed packages against `src/dotfiles`, and steps for a fresh macOS install.

---

## 1. Directories & Files to Back Up

### 🔑 Critical Credentials, Keys & Secrets (High Priority)
* [ ] **`~/.ssh/`** (104 KB) — SSH private/public keys (`id_ed25519`, `id_aws`, `id_aws_ecogistics`, `id_mikrotik`), SSH config, and `known_hosts`.
* [ ] **`~/.gnupg/`** (544 KB) — GPG keyring (`pubring.kbx`), private keys in `private-keys-v1.d/` (**Cluster SOPS secret keys** for production, k0s, etc.), `trustdb.gpg`, `sshcontrol`, and `tofu.db`.
* [ ] **`~/.tokens/`** (204 KB) — Directory containing 50+ individual token/credential files (Anthropic, GitHub, AWS, Backblaze, Cloudflare, DigitalOcean, Storj, Discord, Hermes, Pi, etc.).
* [ ] **`~/.age/`** (16 KB) — Age private & public keys (`nano.key`, `private.key`, `nano.pub`, `public.pub`).
* [ ] **`~/.agent-vault/`** (328 KB) — `agent-vault.db` and CA certificates.
* [ ] **`~/.aws/`** (16 KB) — AWS `config`, `credentials`, and SSO cache/login tokens.
* [ ] **`~/.kube/`** (149 MB) — Kubernetes `config` (active cluster configs, contexts, and credentials) & switch history.
* [ ] **`~/.talos/`** (8 KB) — `config` for Talos Linux Kubernetes cluster administration.
* [ ] **`~/.mc/`** (20 KB) — MinIO Client `config.json` (S3/MinIO alias endpoints and access keys).
* [ ] **`~/.b2_account_info`** — Backblaze B2 CLI authentication database.
* [ ] **`~/Documents/1Password Emergency Kit A3-VNBSQ3-my.pdf`** — 1Password emergency kit.
* [ ] **`~/Downloads/routine.2026-07-24.private-key.pem`** & **`~/Downloads/opnsense/`** — GitHub App private key and OPNsense firewall backups.
* [ ] **`~/src/ecogistics/` non-git credentials**: `id_aws_ecogistics.pks`, `tokens.txt`, `aws-audit-data.tgz`.

---

### ⚙️ Dotfiles & Shell Configs (Not Tracked in `src/dotfiles`)
* [ ] **`~/.p10k.zsh`** (89 KB) — Powerlevel10k theme configuration (referenced in `programs.zsh.initContent`, but **not** stored inside `src/dotfiles`). *(Consider committing to `src/dotfiles`)*
* [ ] **`~/.zshrc.local`** — Local exports (`GITHUB_API_TOKEN`, `HOMEBREW_GITHUB_API_TOKEN`, `FLUX_FORWARD_NAMESPACE`).
* [ ] **`~/export-esp.sh`** — Xtensa/ESP32 toolchain environment variables.
* [ ] **`~/.adventofcode.session`** — Advent of Code session cookie.
* [ ] **`~/.config/gh/hosts.yml`** — GitHub CLI active auth token.
* [ ] **`~/.config/AWSVPNClient/`** — AWS VPN connection profiles and OpenVPN configurations.
* [ ] **`~/.config/rclone/rclone.conf`** — rclone remote endpoint configurations.
* [ ] **`~/.config/worktrunk/config.toml`** — Worktrunk tool configuration.
* [ ] **`~/.config/zed/`** — Zed settings, conversation history, and custom prompts.
* [ ] **`~/.config/joplin-desktop/`** — Joplin SQLite database and encryption settings.
* [ ] **`~/.local/share/atuin/`** (62 MB) — Atuin sync key (`key`) and complete shell command history database (`history.db`).
* [ ] **`~/.sexlife`** — Personal text notes in home root.

---

### 💻 Code Repositories (`~/src/` ~13 GB)
Verify unpushed commits and uncommitted scratchpads before wiping:
* [ ] **`~/src/routine/sync`** — ⚠️ **5 commits ahead of `origin/main` (unpushed!)**
* [ ] **`~/src/wet`** — ⚠️ **Uncommitted new repository with staged and unstaged work**
* [ ] **`~/src/esp/`** — Multiple uncommitted ESP32/Rust projects: `mouse-jiggler`, `something-esp`, `esp-clicker2`, `esp-jiggler`, `test-embassy`.
* [ ] **`~/src/ecogistics/vue-ui`** & **`infrastructure`** — Modified files and untracked terraform access configs.
* [ ] **`~/src/cloudstream`** & **`advent`** — Uncommitted edits and 2025 AoC solution files.
* [ ] **`~/src/archive/`** & **`~/src/tmp/`** — Contains database dumps (`n8n.sql.gz`, `pg-backup.tgz`, `refine-mantine.tgz`, `s3-backup`, `BACKUP`).
* [ ] **`~/src/dotfiles/sandbox/`** — Untracked folder in dotfiles repo.

#### 🗜️ Automated `src/` Backup Script
A migration backup script is provided at [`scripts/backup-src.sh`](./scripts/backup-src.sh) (and via `task backup-src`) to archive `~/src` into a compressed tarball while skipping easily regenerable dependency packages, build artifacts, compiler outputs, test caches, logs, and OS junk:

```bash
# 1. Preview archive size and excluded items (dry run)
task backup-src -- --dry-run
# or: ./scripts/backup-src.sh --dry-run

# 2. Create backup in default location (~/src-backup-YYYYMMDD_HHMMSS.tar.gz)
task backup-src
# or: ./scripts/backup-src.sh

# 3. Create backup directly to an external volume or custom path
task backup-src -- /Volumes/ExternalDrive/src-backup-$(date +%Y%m%d).tar.gz
# or: ./scripts/backup-src.sh /Volumes/ExternalDrive/src-backup-$(date +%Y%m%d).tar.gz

# 4. Verify tarball integrity
tar -tzf ~/src-backup-*.tar.gz > /dev/null && echo "✔ Tarball integrity verified"

# 5. Restore on new machine (from ~)
tar -xzf src-backup-*.tar.gz -C ~/
```

##### 🚫 Excluded Patterns (Regenerable / Ephemeral)
| Category | Excluded Patterns |
|---|---|
| **Node / Web** | `node_modules`, `bower_components`, `.pnpm-store`, `.yarn/cache`, `.yarn/unplugged`, `.npm`, `.turbo`, `.parcel-cache`, `.next`, `.nuxt`, `.output`, `.astro`, `.svelte-kit`, `.docusaurus`, `.angular` |
| **Rust / Cargo** | `target` *(keeps `.cargo/config.toml`)* |
| **Python** | `.venv`, `venv`, `.virtualenvs`, `__pycache__`, `*.pyc`, `*.pyo`, `*.pyd`, `.pytest_cache`, `.mypy_cache`, `.ruff_cache`, `.tox`, `.ipynb_checkpoints` *(keeps `.env*`)* |
| **Ruby / Rails** | `.bundle`, `vendor/bundle`, `.ruby-lsp` |
| **Embedded / Hardware** | `.esphome`, `.pio`, `.platformio` |
| **Java / Elixir** | `.gradle`, `_build`, `.elixir_ls` |
| **IaC / Virtualization** | `.terraform`, `.vagrant`, `.serverless` *(keeps `.terraform.lock.hcl`)* |
| **Build Artifacts & Dist** | `dist`, `build`, `out`, `.jekyll-cache`, `_site`, `.sass-cache` |
| **Test & Coverage** | `coverage`, `.nyc_output` |
| **Logs & Ephemeral Sockets** | `*.log`, `logs`, `npm-debug.log*`, `yarn-debug.log*`, `yarn-error.log*`, `pnpm-debug.log*`, `*.sock`, `*.socket` |
| **OS Metadata & VCS Reflogs** | `.DS_Store`, `._*`, `.Spotlight-V100`, `.Trashes`, `.git/logs` |

##### 🛡️ Preserved Critical Data
* Full Git repositories & commit histories (`.git/` objects, refs, branches, stashes).
* Environment files and local secrets (`.env`, `.env.local`, `.env.development`, `.env.test`).
* Dependency lockfiles (`package-lock.json`, `pnpm-lock.yaml`, `Cargo.lock`, `Gemfile.lock`, `.terraform.lock.hcl`).
* Embedded/Rust configurations (`.cargo/config.toml`, `.cargo/config`).
* Database dumps and local archives in `~/src/tmp/` and `~/src/archive/`.
* Agent settings and configurations (`.claude/`, `.pi/`, `CLAUDE.md`, `AGENTS.md`).

---

### 📁 User Data & App Support
* [ ] **`~/Documents/`** (772 MB) — Includes **`Logseq` notes vault**, `Cap.Notes`, `Career`, `Family`, `Life`, `Routine`, `OpenSCAD` models, and `Bambu` 3D slicer profiles.
* [ ] **`~/Pictures/`** (1.1 GB) — `Photos Library.photoslibrary`, `Photo Booth Library`, scanned receipts, vaccination records, and tax PDFs.
* [ ] **`~/Movies/`** (1.1 GB) — Personal videos and skydiving recordings.
* [ ] **`~/Music/`** (2.5 GB) — Music projects and audio assets.
* [ ] **`~/Desktop/`** (99 MB) — `send/` directory and screenshots.
* [ ] **`~/Library/Fonts/`** (1.2 GB) — Contains **commercial/purchased fonts** like **Dank Mono** (`Dank Mono Bold Nerd Font Complete Mono.otf`, `DankMono-Regular.otf`), `intelone-mono`, `DK Cool Crayon`, etc.
* [ ] **`~/Library/Application Support/Code/User/`** — VS Code custom `settings.json`, `keybindings.json`, `snippets/`, and `profiles/`.
* [ ] **`~/Library/Application Support/Fork/`** & `com.DanPristupov.Fork` — Git Fork custom actions, aliases, and repository list.
* [ ] **`~/Library/Application Support/BambuStudio/` & `BambuStudioBeta/`** — Custom 3D printer and filament presets.
* [ ] **`~/Library/Containers/net.shinyfrog.bear/`** — Bear notes database (verify iCloud sync or create a manual `.bear2bk` export from Bear).
* [ ] **`~/.pi/`**, **`~/.claude/`**, **`~/.codex/`**, **`~/.hermes/`** — AI coding agent configurations, session databases, custom extensions, and auth tokens.
* [ ] **`~/.lima/cleanroom/`** — Lima Linux VM instance.

---

## 2. Homebrew Audit vs. `src/dotfiles`

### Currently declared in `src/dotfiles`:
* **Brews**: `worktrunk`
* **Casks**: `alacritty`, `appcleaner`, `discord`, `font-cascadia-code-nf`, `font-monaspace-nf`, `font-victor-mono-nerd-font`, `fork`, `orbstack`, `slack`, `visual-studio-code`
* **MAS Apps**: `Home Assistant` (1099568401), `WireGuard` (1451685025)

---

### 🔍 Installed Brew Packages **NOT** in `src/dotfiles` (Review List)

#### 🤖 AI & Coding Agent Tools
| Package | Description | Keep? |
|---|---|---|
| `eugene1g/safehouse/agent-safehouse` | macOS sandbox wrapper for coding agents | [ ] |
| `codeburn` | AI token spending visualizer by task/tool/model | [ ] |
| `qqqa` | Fast, stateless shell LLM CLI | [ ] |
| `rtk` | CLI proxy for token optimization | [ ] |

#### ☁️ Cloud, Kubernetes & DevOps
| Package | Description | Notes | Keep? |
|---|---|---|---|
| `ktop` | Top-like CLI monitor for Kubernetes clusters | | [ ] |
| `lima` | Linux virtual machines on macOS | Runs `cleanroom` VM | [ ] |
| `qemu` | Generic machine emulator and virtualizer | | [ ] |
| `terraformer` | CLI to generate Terraform from existing infra | | [ ] |
| `velero` | Kubernetes backup and disaster recovery CLI | | [ ] |
| `b2-tools` | Backblaze B2 storage CLI | | [ ] |

#### 🗄️ Database Tools
| Package | Description | Keep? |
|---|---|---|
| `postgresql@17` | PostgreSQL 17 server & client tools | [ ] |
| `postgis` | Spatial database extender for PostgreSQL | [ ] |
| `pgloader` | Data migration tool to PostgreSQL | [ ] |

#### 🔒 Security, VPN & Networking
| Package | Description | Notes | Keep? |
|---|---|---|---|
| `age` | Simple, modern file encryption tool | Used with `~/.age` | [ ] |
| `git-crypt` | Transparent git encryption | *(Already in Nix `cloud.nix`)* | [ ] |
| `wireguard-tools` | WireGuard tunnel CLI | | [ ] |
| `fping` | Multi-host ping tool | | [ ] |
| `ipmitool` | IPMI server control utility | | [ ] |
| `telnet` | Telnet protocol client | | [ ] |

#### ⚡ Embedded, Hardware & Microcontrollers
| Package | Description | Keep? |
|---|---|---|
| `esphome` | Firmware generator for ESP8266/ESP32 | [ ] |
| `espflash` | Serial flasher for Espressif SoCs | [ ] |
| `platformio` | Embedded development platform CLI | [ ] |
| `probe-rs-tools` | On-chip debugging/flashing tools | [ ] |
| `dfu-util` | USB Device Firmware Upgrade programmer | [ ] |

#### 📄 Media, Build & Conversion Utilities
| Package | Description | Keep? |
|---|---|---|
| `ffmpeg` | Audio/video processing CLI | [ ] |
| `pandoc` | Document converter | [ ] |
| `weasyprint` | HTML to PDF converter | [ ] |
| `youtubedr` | YouTube video downloader CLI | [ ] |
| `cmake` & `ninja` | Build systems | [ ] |
| `git-filter-repo` & `git-who` | Git history rewrite & blame tools | [ ] |
| `mas` | Mac App Store CLI | [ ] |
| `pipx` | Isolated Python package runner | [ ] |
| `ruby-build` | Ruby version builder | [ ] |
| `node-sass` & `sassc` | Sass CSS compilers | [ ] |

---

### 📦 Installed GUI Casks **NOT** in `src/dotfiles`

| Cask | Description | Notes | Keep? |
|---|---|---|---|
| `bitwarden` | Bitwarden desktop app | *(In Nix as `bitwarden-desktop`)* | [ ] |
| `signal` | Signal messaging desktop app | *(In Nix as `signal-desktop`)* | [ ] |
| `logseq` | Knowledge base & outliner app | Uses `~/Documents/Logseq` | [ ] |
| `lobehub` | AI chat & agents UI | | [ ] |
| `balenaetcher` | SD card / USB OS flasher | | [ ] |
| `utm` | QEMU-based virtual machines UI | | [ ] |
| `basictex` | Minimal TeX/LaTeX distribution | | [ ] |

---

### 🏪 Mac App Store Apps (MAS) **NOT** in `src/dotfiles`

| App | App Store ID | Keep? |
|---|---|---|
| **Tailscale** | `1475387142` | [ ] |
| **Bear** | `1091189122` | [ ] |
| **Apple Configurator** | `1037126344` | [ ] |

---

### 🚰 Homebrew Taps Active (None in `src/dotfiles`)
* `eugene1g/safehouse`
* `certak-com/kafkio`
* `k0sproject/tap`
* `kcl-lang/tap`
* `raffis/gitops-zombies`

---

## 3. Other Package Managers & Toolchains

### 🔨 Mise Tool Versions (`~/.config/mise/config.toml`)
* `node = "26.5.0"`
* `ruby = "4.0.1"`
* `bun = "latest"`
* `pnpm = "latest"`
* `opentofu = "latest"`
* `codebuff = "latest"`

### 🦀 Cargo Installed Crates (`~/.cargo/bin`)
* `aoc-cli`, `cargo-cache`, `cargo-espflash`, `cargo-generate`, `cargo-play`, `cargo-script`, `cargo-shuttle`, `cargo-watch`, `esp-generate`, `espflash`, `espup`, `gitql`, `ldproxy`, `loco-cli`, `sea-orm-cli`, `wasm-pack`, `worker-build`

### ☸️ Krew kubectl Plugins (`~/.krew/bin`)
* `kubectl-cnpg` (CloudNativePG)
* `kubectl-crd_wizard`
* `kubectl-exec_as`
* `kubectl-rename_pvc`

### 🌐 Global NPM Packages
* `@earendil-works/pi-coding-agent`
* `@openai/codex`

---

## 4. Fresh Install Setup Checklist

1. **Hostname & Flake Target**:
   * Currently, `flake.nix` defines `darwinConfigurations.fourteen` (matching host `fourteen`).
   * If the new laptop has a different hostname (e.g. `darwinConfigurations.fifteen` or matching new hostname), update `flake.nix` and `hosts/` accordingly.
2. **First-Run Bootstrap**:
   * Install Nix (Determinate Systems installer).
   * Install Homebrew into `/opt/homebrew`.
   * Clone dotfiles into `~/src/dotfiles`.
   * Apply nix-darwin: `nix run nix-darwin -- --flake ~/src/dotfiles#<host>`.
   * Apply home-manager: `home-manager switch --flake ~/src/dotfiles#context`.
3. **Hardware, YubiKey & Secrets**:
   * Insert YubiKey and check card status (`gpg --card-status`).
   * Import restored SOPS secret keys into GPG (`gpg --import`).
   * Configure 1Password CLI session / named pipe for `~/.secrets.env`.
   * Run `atuin login` or restore `~/.local/share/atuin/key` + `history.db`.
4. **Restore Repositories & Data**:
   * Restore `~/src` from backup: `tar -xzf <path_to_backup>/src-backup-*.tar.gz -C ~/`.
   * Restore `~/Documents`, `~/Pictures`, and other personal data.
   * Run package install in active repos as needed (`pnpm install`, `cargo build`, `bundle install`).
