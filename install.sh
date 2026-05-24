#!/usr/bin/env bash
set -euo pipefail

# kiro-rails-light - Installer with upgrade support
# Usage: curl -fsSL https://raw.githubusercontent.com/sourjya/kiro-rails-light/main/install.sh | bash
#
# Behavior:
#   Fresh install  - downloads everything, writes version file
#   Upgrade        - overwrites all managed files, never touches user-lib-overrides.md

REPO="sourjya/kiro-rails-light"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"
CURRENT_VERSION="0.3.0"
VERSION_FILE=".kiro/.kiro-rails-light-version"
OVERRIDES_FILE=".kiro/steering/user-lib-overrides.md"

# ──────────────────────────────────────────────
# All managed files - overwritten on every upgrade
# ──────────────────────────────────────────────
MANAGED_FILES=(
  .kiro/steering/api-design-package-structure.md
  .kiro/steering/code-quality.md
  .kiro/steering/testing-standards.md
  .kiro/steering/versioning-git.md
  .kiro/steering/pitfalls.md
  .kiro/steering/change-discipline.md
  .kiro/hooks/fix-spiral-detector.kiro.hook
  .kiro/hooks/type-check-on-stop.kiro.hook
  .kiro/hooks/package-manifest-verify.kiro.hook
  .kiro/hooks/comment-standards-check.kiro.hook
  .kiro/prompts/review-dependency-risk.md
  .kiro/prompts/review-test-quality.md
  .kiro/prompts/review-api-surface.md
  scripts/export-to-tools.sh
)

# ──────────────────────────────────────────────
# Stale files - removed during upgrade (from previous versions)
# ──────────────────────────────────────────────
STALE_FILES=(
  # None yet - add files here when they are renamed or removed in future versions
)

# ──────────────────────────────────────────────
# Directories to create
# ──────────────────────────────────────────────
DIRS=(
  .kiro/steering
  .kiro/hooks
  .kiro/prompts
  scripts
)

# ──────────────────────────────────────────────
# Safety checks
# ──────────────────────────────────────────────
if [ "$(pwd)" = "$HOME" ] || [ "$(pwd)" = "/" ]; then
  echo "Error: don't run this in your home or root directory. cd into your project first."
  exit 1
fi

# ──────────────────────────────────────────────
# Detect install type
# ──────────────────────────────────────────────
installed_version=""
install_type="fresh"

if [ -f "$VERSION_FILE" ]; then
  installed_version=$(cat "$VERSION_FILE")
  if [ "$installed_version" = "$CURRENT_VERSION" ]; then
    echo "kiro-rails-light v$CURRENT_VERSION is already installed. Nothing to do."
    exit 0
  fi
  install_type="upgrade"
  echo "Upgrading kiro-rails-light: v$installed_version -> v$CURRENT_VERSION"
elif ls .kiro/steering/*.md &>/dev/null 2>&1; then
  install_type="upgrade"
  installed_version="0.0.0"
  echo "Detected existing kiro-rails-light files (no version file). Upgrading to v$CURRENT_VERSION"
else
  echo "Installing kiro-rails-light v$CURRENT_VERSION into $(pwd)..."
fi

# ──────────────────────────────────────────────
# Create directories
# ──────────────────────────────────────────────
for dir in "${DIRS[@]}"; do
  mkdir -p "$dir"
done

# ──────────────────────────────────────────────
# Download managed files
# ──────────────────────────────────────────────
downloaded=0
updated=0
failed=0

total=${#MANAGED_FILES[@]}
current=0

for file in "${MANAGED_FILES[@]}"; do
  current=$((current + 1))
  printf "\r  Downloading [%d/%d] %-50s" "$current" "$total" "$(basename "$file")"
  if [ -f "$file" ] && [ "$install_type" = "upgrade" ]; then
    if curl -fsSL "$BASE_URL/$file" -o "$file" 2>/dev/null; then
      updated=$((updated + 1))
    else
      echo ""
      echo "  Warning: could not download $file"
      failed=$((failed + 1))
    fi
  else
    if curl -fsSL "$BASE_URL/$file" -o "$file" 2>/dev/null; then
      downloaded=$((downloaded + 1))
    else
      echo ""
      echo "  Warning: could not download $file"
      failed=$((failed + 1))
    fi
  fi
done
echo ""

# ──────────────────────────────────────────────
# User overrides - never overwrite
# ──────────────────────────────────────────────
if [ ! -f "$OVERRIDES_FILE" ]; then
  if curl -fsSL "$BASE_URL/$OVERRIDES_FILE" -o "$OVERRIDES_FILE" 2>/dev/null; then
    downloaded=$((downloaded + 1))
  fi
fi

# ──────────────────────────────────────────────
# Remove stale files (upgrade only)
# ──────────────────────────────────────────────
removed=0
if [ "$install_type" = "upgrade" ]; then
  for file in "${STALE_FILES[@]}"; do
    if [ -f "$file" ]; then
      rm "$file"
      removed=$((removed + 1))
      echo "  Removed stale: $file"
    fi
  done
fi

# ──────────────────────────────────────────────
# Make scripts executable
# ──────────────────────────────────────────────
chmod +x scripts/*.sh 2>/dev/null || true

# ──────────────────────────────────────────────
# Write version file
# ──────────────────────────────────────────────
echo "$CURRENT_VERSION" > "$VERSION_FILE"

# ──────────────────────────────────────────────
# Dependency check
# ──────────────────────────────────────────────
echo ""
echo "Dependency check:"

dep_ok=0
dep_missing=0

if command -v git &>/dev/null; then
  echo "  ✓ git $(git --version 2>/dev/null | sed 's/git version //')"
  dep_ok=$((dep_ok + 1))
else
  echo "  ✗ git — fix-spiral-detector hook will not work"
  dep_missing=$((dep_missing + 1))
fi

if command -v node &>/dev/null; then
  echo "  ✓ node $(node --version 2>/dev/null)"
  dep_ok=$((dep_ok + 1))
else
  echo "  · node — type-check-on-stop will skip TypeScript checks"
  dep_missing=$((dep_missing + 1))
fi

if command -v npm &>/dev/null; then
  echo "  ✓ npm $(npm --version 2>/dev/null)"
  dep_ok=$((dep_ok + 1))
else
  echo "  · npm — package-manifest-verify cannot run npm pack --dry-run"
  dep_missing=$((dep_missing + 1))
fi

if command -v ruff &>/dev/null; then
  echo "  ✓ ruff $(ruff --version 2>/dev/null | head -1)"
  dep_ok=$((dep_ok + 1))
else
  echo "  · ruff — type-check-on-stop will skip Python checks"
  dep_missing=$((dep_missing + 1))
fi

echo ""
if [ $dep_missing -eq 0 ]; then
  echo "All hooks fully operational."
else
  echo "$dep_ok found, $dep_missing optional missing. Steering files work regardless."
fi

# ──────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────
echo ""
if [ "$install_type" = "fresh" ]; then
  echo "Done! $downloaded files installed."
  echo ""
  echo "Your customization file: .kiro/steering/user-lib-overrides.md"
  echo "  This is the only file you need to edit. All other files are managed"
  echo "  and will be updated automatically on upgrade."
  echo ""
  echo "Next steps:"
  echo "  1. Edit .kiro/steering/user-lib-overrides.md with your lib's details"
  echo "  2. git add .kiro/ scripts/ && git commit -m 'feat: add kiro-rails-light steering'"
else
  echo "Done! $downloaded new, $updated updated, $removed removed."
  [ $removed -gt 0 ] && echo "  Stale files from previous versions were cleaned up."
  echo ""
  echo "Your customization file was not modified: .kiro/steering/user-lib-overrides.md"
fi
