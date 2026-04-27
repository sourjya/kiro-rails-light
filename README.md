# kiro-rails-light

Lightweight engineering standards for shared libraries. The little sibling of [kiro-rails](https://github.com/sourjya/kiro-rails).

**kiro-rails** is for full-stack applications (frontend + backend + database + UX + security reviews).
**kiro-rails-light** is for shared libraries (small, focused packages consumed by multiple apps).

## What's Included

| Steering File | What It Covers |
|---------------|---------------|
| `api-design-package-structure.md` | Public API rules, minimal surface area, package layout, dependency discipline, consumer integration (ADR-008) |
| `code-quality.md` | Commenting standards, error handling, design principles, adapter pattern |
| `testing-standards.md` | TDD discipline, test organization, coverage requirements |
| `versioning-git.md` | Semver, release checklist, CHANGELOG format, git conventions, change discipline |
| `pitfalls.md` | 10 common shared library anti-patterns and how to avoid them |

## What's NOT Included (vs kiro-rails)

- No UX patterns (shared libs are headless)
- No database conventions (shared libs don't own databases)
- No security review tiers (overkill for 10-file packages)
- No frontend code organization (no feature-sliced design)
- No ViewGraph workflow (no UI to review)
- No WSL shell workarounds (environment-specific)

## Install

```bash
cd ~/coding/shared-libs/my-new-lib
curl -fsSL https://raw.githubusercontent.com/sourjya/kiro-rails-light/main/install.sh | bash
```

This creates `.kiro/steering/` with all steering files. Kiro IDE and CLI pick them up automatically.

**Does not overwrite** existing files. To update, delete the file and re-run.

## Who This Is For

Shared libraries in the ChaosLabz ecosystem:
- `beacon-ts` - frontend observability
- `shortcut-hints` - keyboard shortcut overlay
- `form-engine` - headless form engine
- `approval-engine` - approval workflow state machine
- `inbound-mail` - email processing

And any future shared package that needs engineering discipline without full-stack overhead.

## License

Proprietary - ChaosLabz

## Author

Sourjya S. Sen - sourjya.sen@gmail.com
