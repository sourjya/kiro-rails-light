#!/usr/bin/env bash
# kiro-rails-light installer
# Installs lightweight shared library engineering standards into .kiro/
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/sourjya/kiro-rails-light/main/install.sh | bash
#
# What it does:
#   1. Creates .kiro/steering/ if it doesn't exist
#   2. Downloads steering files (does NOT overwrite existing files)
#   3. Prints summary

set -euo pipefail

REPO="sourjya/kiro-rails-light"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

STEERING_FILES=(
  "api-design-package-structure.md"
  "code-quality.md"
  "testing-standards.md"
  "versioning-git.md"
  "pitfalls.md"
)

echo "kiro-rails-light installer"
echo "=========================="
echo ""

# Create directories
mkdir -p .kiro/steering

# Download steering files
installed=0
skipped=0
for file in "${STEERING_FILES[@]}"; do
  target=".kiro/steering/${file}"
  if [ -f "$target" ]; then
    echo "  SKIP  ${target} (already exists)"
    ((skipped++)) || true
  else
    curl -fsSL "${BASE_URL}/.kiro/steering/${file}" -o "$target"
    echo "  ADD   ${target}"
    ((installed++)) || true
  fi
done

echo ""
echo "Done: ${installed} installed, ${skipped} skipped"
echo ""
echo "Steering files are in .kiro/steering/"
echo "Kiro IDE and CLI will pick them up automatically."
echo ""
echo "To update existing files, delete them first and re-run this script."
