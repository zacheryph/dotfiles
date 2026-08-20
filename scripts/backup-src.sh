#!/usr/bin/env bash
# ==============================================================================
# backup-src.sh
# ------------------------------------------------------------------------------
# Creates a compressed tarball backup of ~/src while excluding easily
# regenerable dependencies (node_modules, target, .venv), build artifacts,
# caches, logs, and OS junk.
#
# Part of laptop migration procedures documented in MIGRATION.md.
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Defaults & Configuration
# ------------------------------------------------------------------------------
SRC_DIR="${SRC_DIR:-$HOME/src}"
DEFAULT_OUT_NAME="src-backup-$(date +%Y%m%d_%H%M%S).tar.gz"
DEST_FILE=""
DRY_RUN=false
VERBOSE=false

# ------------------------------------------------------------------------------
# Exclusion Patterns
# ------------------------------------------------------------------------------
# These match patterns anywhere in directory tree.
EXCLUDES=(
  # --- macOS / OS Metadata ---
  '.DS_Store'
  '._*'
  '.Spotlight-V100'
  '.Trashes'

  # --- Runtime sockets / IPC (cannot be archived by pax/tar) ---
  '*.sock'
  '*.socket'

  # --- Version Control internal ephemeral logs (keeps git history intact) ---
  '.git/logs'

  # --- Node.js / JavaScript / TypeScript Dependencies & Caches ---
  'node_modules'
  'bower_components'
  '.pnpm-store'
  '.yarn/cache'
  '.yarn/unplugged'
  '.npm'
  '.turbo'
  '.parcel-cache'
  '.next'
  '.nuxt'
  '.output'
  '.astro'
  '.svelte-kit'
  '.docusaurus'
  '.angular'

  # --- Rust / Cargo ---
  # Note: Excludes target/ build artifacts; keeps .cargo/config.toml
  'target'

  # --- Python / Virtual Environments & Caches ---
  # Note: Keeps .env and .env.* configuration files; only excludes venvs and bytecode
  '.venv'
  'venv'
  '.virtualenvs'
  '__pycache__'
  '*.pyc'
  '*.pyo'
  '*.pyd'
  '.pytest_cache'
  '.mypy_cache'
  '.ruff_cache'
  '.tox'
  '.ipynb_checkpoints'

  # --- Ruby / Rails ---
  '.bundle'
  'vendor/bundle'
  '.ruby-lsp'

  # --- Embedded / Microcontrollers / ESP ---
  '.esphome'
  '.pio'
  '.platformio'

  # --- Java / JVM / Gradle ---
  '.gradle'

  # --- Elixir / Erlang ---
  '_build'
  '.elixir_ls'

  # --- Infrastructure / Terraform / Virtualization ---
  # Note: Excludes provider binary downloads; keeps .terraform.lock.hcl
  '.terraform'
  '.vagrant'
  '.serverless'

  # --- General Build Outputs & Distributions ---
  'dist'
  'build'
  'out'
  '.jekyll-cache'
  '_site'
  '.sass-cache'

  # --- Test Coverage Reports ---
  'coverage'
  '.nyc_output'

  # --- General Caches ---
  '.cache'

  # --- Logs ---
  '*.log'
  'logs'
  'npm-debug.log*'
  'yarn-debug.log*'
  'yarn-error.log*'
  'pnpm-debug.log*'

  # --- Temporary / Swap files ---
  '*.swp'
  '*.swo'
  '*~'
)

EXTRA_EXCLUDES=()

# ------------------------------------------------------------------------------
# Help & Usage
# ------------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS] [DESTINATION_TARBALL]

Back up ~/src into a compressed tarball, ignoring regenerable dependencies,
build artifacts, caches, and logs.

Arguments:
  DESTINATION_TARBALL    Output tarball path (default: ~/${DEFAULT_OUT_NAME})

Options:
  -s, --source DIR       Source directory to back up (default: ~/src)
  -o, --output FILE      Destination archive file
  -n, --dry-run          Simulate backup and display matching files / stats
  -v, --verbose          Show files being archived
  -x, --exclude PATTERN  Add custom exclusion pattern (can be used multiple times)
  -h, --help             Show this help message

Examples:
  # Default backup to ~/src-backup-YYYYMMDD_HHMMSS.tar.gz
  $(basename "$0")

  # Backup to an external drive or specific path
  $(basename "$0") /Volumes/BackupDrive/src-backup.tar.gz

  # Dry run to inspect files and calculated size
  $(basename "$0") --dry-run
EOF
  exit 0
}

# ------------------------------------------------------------------------------
# Parse Arguments
# ------------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      ;;
    -s|--source)
      SRC_DIR="$2"
      shift 2
      ;;
    -o|--output)
      DEST_FILE="$2"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -x|--exclude)
      EXTRA_EXCLUDES+=("$2")
      shift 2
      ;;
    -*)
      echo "Error: Unknown option: $1" >&2
      usage
      ;;
    *)
      if [[ -z "$DEST_FILE" ]]; then
        DEST_FILE="$1"
      else
        echo "Error: Unexpected argument: $1" >&2
        usage
      fi
      shift
      ;;
  esac
done

# Default output file if not specified
if [[ -z "$DEST_FILE" ]]; then
  DEST_FILE="$HOME/$DEFAULT_OUT_NAME"
fi

# Expand paths
SRC_DIR="$(cd "$SRC_DIR" 2>/dev/null && pwd || echo "$SRC_DIR")"

# Validate source directory
if [[ ! -d "$SRC_DIR" ]]; then
  echo "Error: Source directory '$SRC_DIR' does not exist." >&2
  exit 1
fi

# Merge all excludes
ALL_EXCLUDES=("${EXCLUDES[@]}" "${EXTRA_EXCLUDES[@]}")

# Build tar exclude arguments
TAR_EXCLUDE_ARGS=()
for pattern in "${ALL_EXCLUDES[@]}"; do
  TAR_EXCLUDE_ARGS+=("--exclude=${pattern}")
done

PARENT_DIR="$(dirname "$SRC_DIR")"
BASE_DIR="$(basename "$SRC_DIR")"

echo "=================================================================="
echo "📦 Source Backup: $SRC_DIR"
echo "=================================================================="
echo "• Source:        $SRC_DIR"
echo "• Destination:   $DEST_FILE"
echo "• Dry run:       $DRY_RUN"
echo "• Exclusions:    ${#ALL_EXCLUDES[@]} patterns configured"
echo "------------------------------------------------------------------"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "🔍 Simulating backup (dry-run)..."
  echo "Calculating uncompressed archive size and file count..."

  FILE_COUNT=0
  TOTAL_BYTES=0

  # Count files and estimate uncompressed size using bsdtar stream
  TOTAL_BYTES=$(COPYFILE_DISABLE=1 tar -cf - "${TAR_EXCLUDE_ARGS[@]}" -C "$PARENT_DIR" "$BASE_DIR" 2>/dev/null | wc -c | tr -d ' ')
  
  HUMAN_SIZE=$(awk "BEGIN {
    b = $TOTAL_BYTES;
    if (b >= 1073741824) printf \"%.2f GB\", b/1073741824;
    else if (b >= 1048576) printf \"%.2f MB\", b/1048576;
    else if (b >= 1024) printf \"%.2f KB\", b/1024;
    else printf \"%d B\", b;
  }")

  echo "✔ Estimated uncompressed size: $HUMAN_SIZE ($TOTAL_BYTES bytes)"
  echo "Dry run complete. No archive created."
  exit 0
fi

# Ensure destination directory exists
DEST_DIR="$(dirname "$DEST_FILE")"
mkdir -p "$DEST_DIR"

echo "⏳ Creating archive..."
START_TIME=$(date +%s)

TAR_FLAGS=("-cf" "$DEST_FILE")
if [[ "$VERBOSE" == "true" ]]; then
  TAR_FLAGS=("-cvf" "$DEST_FILE")
fi

# Disable macOS extended attributes / AppleDouble files in archive for clean tarball
# Check if pigz is available for fast multi-core gzip compression
if command -v pigz >/dev/null 2>&1; then
  echo "⚡ Using pigz for accelerated multi-threaded compression..."
  COPYFILE_DISABLE=1 tar -cf - "${TAR_EXCLUDE_ARGS[@]}" -C "$PARENT_DIR" "$BASE_DIR" | pigz > "$DEST_FILE"
else
  # Standard gzip via bsdtar
  COPYFILE_DISABLE=1 tar -czf "$DEST_FILE" "${TAR_EXCLUDE_ARGS[@]}" -C "$PARENT_DIR" "$BASE_DIR"
fi

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# File size
ARCHIVE_SIZE=$(ls -lh "$DEST_FILE" | awk '{print $5}')

echo "------------------------------------------------------------------"
echo "✅ Backup successfully created in ${DURATION}s!"
echo "• File: $DEST_FILE"
echo "• Size: $ARCHIVE_SIZE"
echo ""
echo "To verify the archive integrity, run:"
echo "  tar -tzf \"$DEST_FILE\" > /dev/null && echo 'Archive OK'"
echo ""
echo "To extract/restore to ~/, run:"
echo "  tar -xzf \"$DEST_FILE\" -C ~/"
echo "=================================================================="
