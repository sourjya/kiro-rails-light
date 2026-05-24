#!/usr/bin/env bash
set -euo pipefail

# kiro-rails-light: Export steering files to other AI coding tools
# Usage: ./scripts/export-to-tools.sh --all
#        ./scripts/export-to-tools.sh --cursor
#        ./scripts/export-to-tools.sh --claude
#        ./scripts/export-to-tools.sh --copilot
#        ./scripts/export-to-tools.sh --codex

STEERING_DIR=".kiro/steering"

# ──────────────────────────────────────────────
# Collect steering content (user overrides first)
# ──────────────────────────────────────────────
collect_steering() {
  local content=""

  # User overrides first (if exists and has uncommented content)
  if [ -f "$STEERING_DIR/user-lib-overrides.md" ]; then
    local overrides
    overrides=$(grep -v '^<!--' "$STEERING_DIR/user-lib-overrides.md" | grep -v '^\-\-\-' | grep -v '^inclusion:' | sed '/^$/N;/^\n$/d')
    if [ -n "$overrides" ]; then
      content+="$overrides"$'\n\n'
    fi
  fi

  # All other steering files
  for file in "$STEERING_DIR"/*.md; do
    [ -f "$file" ] || continue
    [ "$(basename "$file")" = "user-lib-overrides.md" ] && continue
    # Strip frontmatter
    content+=$(sed '/^---$/,/^---$/d' "$file")
    content+=$'\n\n'
  done

  echo "$content"
}

# ──────────────────────────────────────────────
# Export functions
# ──────────────────────────────────────────────
export_cursor() {
  echo "Generating .cursorrules..."
  collect_steering > .cursorrules
  echo "  Created .cursorrules ($(wc -l < .cursorrules) lines)"
}

export_claude() {
  mkdir -p .claude
  echo "Generating .claude/CLAUDE.md..."
  collect_steering > .claude/CLAUDE.md
  echo "  Created .claude/CLAUDE.md ($(wc -l < .claude/CLAUDE.md) lines)"
}

export_copilot() {
  mkdir -p .github
  echo "Generating .github/copilot-instructions.md..."
  collect_steering > .github/copilot-instructions.md
  echo "  Created .github/copilot-instructions.md ($(wc -l < .github/copilot-instructions.md) lines)"
}

export_codex() {
  echo "Generating AGENTS.md..."
  collect_steering > AGENTS.md
  echo "  Created AGENTS.md ($(wc -l < AGENTS.md) lines)"
}

# ──────────────────────────────────────────────
# Parse arguments
# ──────────────────────────────────────────────
if [ $# -eq 0 ]; then
  echo "Usage: $0 --all | --cursor | --claude | --copilot | --codex"
  echo ""
  echo "Exports kiro-rails-light steering files to other AI tool formats."
  echo "Regenerate after any steering file change."
  exit 1
fi

case "$1" in
  --all)
    export_cursor
    export_claude
    export_copilot
    export_codex
    echo ""
    echo "Done. Add generated files to .gitignore or commit them."
    ;;
  --cursor)  export_cursor ;;
  --claude)  export_claude ;;
  --copilot) export_copilot ;;
  --codex)   export_codex ;;
  *)
    echo "Unknown option: $1"
    echo "Usage: $0 --all | --cursor | --claude | --copilot | --codex"
    exit 1
    ;;
esac
