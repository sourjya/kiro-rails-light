---
inclusion: always
---

# Versioning and Git Workflow

Release process, semver discipline, and git conventions for shared libraries.

## Semantic Versioning - MANDATORY

### Pre-1.0 (beta)

- **PATCH** (0.1.x): bug fixes, no API change
- **MINOR** (0.x.0): new exports, new features, OR breaking changes
- Breaking changes allowed on minor bumps (beta expectation)

### Post-1.0 (stable)

- **PATCH**: bug fixes, backward compatible
- **MINOR**: new features, backward compatible
- **MAJOR**: breaking changes

## Release Checklist

1. All tests pass (`npm test` or `pytest`)
2. Build succeeds (`npm run build`)
3. Update version in `package.json` (or `pyproject.toml`)
4. Update `CHANGELOG.md` (Keep a Changelog format)
5. Commit: `chore: release vX.X.X`
6. Tag: `git tag -a vX.X.X -m "vX.X.X - description"`
7. Push: `git push origin main --tags`

## CHANGELOG Format

```markdown
## [0.2.0] - 2026-05-01
### Added
- New `validateAsync` function
### Changed
- BREAKING: `validateField` returns `FieldError | null` instead of `string | null`
### Fixed
- Email validation accepts `+` in local part
```

## Git Conventions - MANDATORY

### Branch Naming

```
feat/{description}     new feature or export
fix/{description}      bug fix
chore/{description}    tooling, deps, config, release
test/{description}     tests only
```

### Commit Messages (Conventional Commits)

```
feat: add validateAsync for server-side validation
fix: email validator accepts + in local part
chore: release v0.2.0
test: add edge case tests for number validation
docs: update README with new API
```

### Rules

1. **Every commit builds and passes tests** - no WIP commits
2. **One logical change per commit** - not "fix everything"
3. **Tag every release** with annotated tag
4. **Never force-push main after consumers have pinned a tag**
5. **Never amend pushed commits** - create a new fix commit instead

## Change Discipline - MANDATORY

1. **Minimal changes** - modify as few lines as possible
2. **No drive-by refactors** - don't clean up unrelated code
3. **No unsolicited dependency updates** - don't upgrade packages unless the task requires it
4. **Review your diff before committing** - every line should relate to the task
