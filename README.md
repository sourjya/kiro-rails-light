# kiro-rails-light

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/sourjya/kiro-rails-light)](https://github.com/sourjya/kiro-rails-light/commits/main)

Lightweight engineering standards for shared libraries. The little sibling of [kiro-rails](https://github.com/sourjya/kiro-rails).

**kiro-rails** is for full-stack applications (frontend + backend + database + UX + security reviews).
**kiro-rails-light** is for shared libraries (small, focused packages consumed by multiple apps).

**What's included:** [7 steering files](.kiro/steering/) · [4 automated hooks](.kiro/hooks/) · [3 review prompts](.kiro/prompts/) · [multi-tool export](scripts/export-to-tools.sh)

## Quick Start

**Linux / macOS / Git Bash / WSL:**

```bash
cd your-shared-lib
curl -fsSL https://raw.githubusercontent.com/sourjya/kiro-rails-light/main/install.sh | bash
```

**PowerShell (Windows):**

```powershell
cd your-shared-lib
curl.exe -fsSL https://raw.githubusercontent.com/sourjya/kiro-rails-light/main/install.ps1 -o install.ps1; powershell -ExecutionPolicy Bypass -File install.ps1; Remove-Item install.ps1
```

Safe to re-run: on upgrade, all managed files are updated automatically while `user-lib-overrides.md` (your only customization file) is never touched. Stale files from previous versions are cleaned up.

## Why Use This

AI coding agents are stateless — they don't remember your engineering standards between sessions. Without guardrails, agents drift: skipping tests, adding unnecessary dependencies, breaking public APIs, or publishing packages with missing files.

This template encodes shared library best practices as **steering files** that your agent reads on every interaction.

**What changes when you add these steering files:**

| Without steering | With steering |
|-----------------|---------------|
| Agent adds runtime dependencies freely | Zero runtime deps enforced — peer deps for frameworks |
| Tests sometimes, maybe | TDD mandatory — RED/GREEN/REFACTOR every time |
| Fix-on-fix spirals (7+ commits) | Fix depth rule — stop after 2 failed fixes, find root cause |
| Missing files in published package | Package manifest verification hook catches it automatically |
| Type errors slip through | Type-check runs after every agent response |
| Undocumented exports | Comment standards enforced before every commit |
| Breaking changes without version bumps | Consumer impact awareness rules |
| Deep relative imports | Clean import paths enforced |

## What's NOT Included (vs kiro-rails)

- No UX patterns (shared libs are headless)
- No database conventions (shared libs don't own databases)
- No security review tiers (overkill for 10-file packages)
- No frontend code organization (no feature-sliced design)
- No documentation taxonomy (README.md is sufficient for libs)
- No spec workflow skills (specs live in the consuming project)
- No changelog rolling (libs have simple changelogs)

## Project Structure

```
.kiro/
├── steering/                 # AI behavioral rules (always-on)
│   ├── api-design-package-structure.md   # Public API, package layout, dependency discipline
│   ├── code-quality.md                   # Comments, error handling, design principles, adapters
│   ├── testing-standards.md              # TDD, test organization, coverage requirements
│   ├── versioning-git.md                 # Semver, release checklist, git conventions
│   ├── pitfalls.md                       # 10 shared library anti-patterns
│   ├── change-discipline.md              # Fix depth, permissions, scope, consumer impact
│   └── user-lib-overrides.md             # YOUR customizations — never overwritten
├── hooks/                    # Automated quality gates
│   ├── fix-spiral-detector.kiro.hook     # Warns on 3+ consecutive fix commits
│   ├── type-check-on-stop.kiro.hook      # Runs tsc/ruff after agent responds
│   ├── package-manifest-verify.kiro.hook # Verifies npm pack includes expected files
│   └── comment-standards-check.kiro.hook # Enforces docstrings before commit
└── prompts/                  # On-demand review prompts
    ├── review-dependency-risk.md         # Supply chain, license, bundle size audit
    ├── review-test-quality.md            # Assertion quality, coverage, flakiness audit
    └── review-api-surface.md             # Public API minimalism, consistency, ergonomics

scripts/
└── export-to-tools.sh       # Export steering to Cursor, Claude, Copilot, Codex
```

## Steering Files

| File | What It Covers |
|------|----------------|
| `api-design-package-structure.md` | Single entry point, minimal surface area, zero side effects, headless design, breaking change rules, package layout, dependency discipline, consumer integration |
| `code-quality.md` | Module/function docstrings, error handling (fail fast, typed errors), design principles (pure functions, composition, adapter pattern) |
| `testing-standards.md` | TDD mandate (RED/GREEN/REFACTOR), test organization (`tests/` flat), coverage requirements (100% of exports), test tooling |
| `versioning-git.md` | Semver (pre-1.0 and post-1.0), release checklist, CHANGELOG format, branch naming, conventional commits, change discipline |
| `pitfalls.md` | Kitchen sink, leaky abstraction, version drift, phantom dependency, React coupling, barrel bloat, shared state, over-abstraction, missing README, test-in-isolation-only |
| `change-discipline.md` | Permission boundaries (always/ask/never), fix depth rule (2-fix limit), copy-paste verification, package manifest verification, change scope, consumer impact awareness |
| `user-lib-overrides.md` | **Your file** — library identity, peer deps, build tool, test runner, exports strategy, consumer integration, library-specific rules |

### Customization

All steering files except `user-lib-overrides.md` are managed and overwritten on upgrade. Your library-specific settings go in one file:

- `.kiro/steering/user-lib-overrides.md` — lib name, language, peer deps, build tool, custom rules

## Automated Hooks

| Hook | Trigger | What It Does |
|------|---------|--------------|
| Fix Spiral Detector | Prompt submit | Warns if 3+ consecutive `fix:` commits — triggers root cause analysis |
| Type Check on Stop | Agent stop | Runs `tsc --noEmit` or `ruff check` after agent finishes responding |
| Package Manifest Verify | `package.json`/`pyproject.toml` edited | Runs `npm pack --dry-run` to verify published artifact includes expected files |
| Comment Standards Check | Pre-commit | Verifies staged source files have proper docstrings, no parser-breaking comments |

## Review Prompts

Run these manually when you want a deep audit:

| Prompt | What It Audits |
|--------|---------------|
| `review-dependency-risk.md` | Dependency necessity, peer dep hygiene, transitive amplification, license compliance, maintainer health, bundle size, supply chain integrity, consumer impact |
| `review-test-quality.md` | Assertion quality, export coverage, edge cases, over-mocking, consumer-perspective testing, flakiness, breaking change detection |
| `review-api-surface.md` | Surface minimalism, type safety, naming consistency, options pattern, breaking change risk, side effects, documentation completeness, consumer ergonomics |

## Multi-Tool Export

The steering files work with any MCP-compatible agent. Export to other tools:

```bash
./scripts/export-to-tools.sh --all
```

Generates:
- `.cursorrules` — for [Cursor](https://cursor.com)
- `.claude/CLAUDE.md` — for [Claude Code](https://claude.ai)
- `.github/copilot-instructions.md` — for [GitHub Copilot](https://github.com/features/copilot)
- `AGENTS.md` — for [Codex](https://openai.com/codex), [Cline](https://github.com/cline/cline), and other AGENTS.md-compatible tools

Individual exports: `--cursor`, `--claude`, `--copilot`, `--codex`.

## Upgrade Behavior

The installer tracks its version in `.kiro/.kiro-rails-light-version`. On re-run:

- **Same version**: exits immediately ("nothing to do")
- **New version**: overwrites all managed files, preserves `user-lib-overrides.md`, removes stale files from previous versions
- **No version file but files exist**: treats as upgrade from v0.0.0

## Development Workflow

### TDD Cycle (Mandatory)

1. **RED**: Write a failing test first
2. **GREEN**: Write minimal code to make it pass
3. **REFACTOR**: Clean up while keeping tests green

### Release Checklist

1. All tests pass
2. Build succeeds
3. Update version in `package.json` / `pyproject.toml`
4. Update `CHANGELOG.md`
5. Commit: `chore: release vX.X.X`
6. Tag: `git tag -a vX.X.X -m "vX.X.X - description"`
7. Push: `git push origin main --tags`
8. **Test in a real consumer before tagging**

### Fix Depth Rule

If your second fix attempt introduces yet another failure:
1. STOP
2. Map all code paths
3. Document what you tried
4. Find the root cause, not another symptom

## Who This Is For

Any shared library that needs engineering discipline without full-stack overhead:
- TypeScript packages (React hooks, utilities, engines)
- Python packages (CLI tools, SDK wrappers, validators)
- Any focused package consumed by multiple applications

## License

MIT License — Sourjya S. Sen
