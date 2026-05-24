---
inclusion: always
---

# Change Discipline

Rules governing what you can change, fix depth limits, and verification requirements for shared libraries.

## Permission Boundaries - MANDATORY

### ✅ Always Allowed
- Read any file in the repository
- Run linting, type checking, and tests
- Edit source files within the scope of the current task
- Update CHANGELOG.md and README.md

### ⚠️ Ask First
- Adding or removing dependencies (even dev deps)
- Changing the public API surface (new exports, changed signatures)
- Modifying build configuration (vite.config, tsconfig, pyproject.toml)
- Changing peer dependency version ranges

### 🚫 Never
- Commit secrets or credentials
- Force push to `main` after consumers have pinned a tag
- Modify `dist/` or generated files
- Remove or weaken existing tests
- Change code outside the scope of the current task
- Break backward compatibility without a version bump

## Fix Depth Rule — MANDATORY

**If a fix introduces a new failure, STOP. Do not chain fixes blindly.**

### Rules

1. **Two-fix limit** — if your second fix attempt for the same issue introduces yet another failure, STOP immediately.
2. **Map all paths** — before attempting fix #3, read the FULL integration context: all consumers, all edge cases, the complete call chain.
3. **Root cause, not symptoms** — each failed fix is evidence you're treating a symptom. Step back and identify the actual root cause.
4. **Document what you tried** — before the third attempt, write down: what fix #1 did, why it failed, what fix #2 did, why it failed. The pattern reveals the real problem.
5. **Ask for help** — if you cannot identify the root cause after mapping all paths, say so. Don't keep guessing.

## Copy-Paste Verification — MANDATORY

**After copying code from another context, verify EVERY field makes sense in the new context.**

### Rules

1. **Review all values** — default values, field names, identifiers, paths, error messages. Each must be correct for the NEW context, not the source.
2. **Check return types** — if you copied a function that returns a specific shape, verify that shape is correct HERE.
3. **Check config references** — if the copied code references a config file, manifest, or package.json entry, verify that entry exists for the new context.
4. **Check imports** — copied code often imports from paths that don't exist in the destination. Fix before running.

## Package Manifest Verification — MANDATORY

**After creating any file that should be published, verify it's included in the manifest.**

### Rules

1. **npm `files` array** — after creating new directories or entry points, verify they're listed in `package.json` `files`. Run `npm pack --dry-run` to confirm.
2. **pyproject.toml `include`** — after creating new Python modules, verify they're included in the package build.
3. **bin entries** — after creating CLI entry points, verify the `bin` field points to the correct file.
4. **exports field** — after adding subpath exports, verify the `exports` map in package.json is correct.
5. **After adding any import** — verify the dependency is declared in the manifest. Don't use undeclared packages.

## Change Scope Discipline - MANDATORY

1. **Minimal changes** — modify as few lines as possible while correctly solving the problem.
2. **No drive-by refactors** — don't clean up unrelated code while fixing a bug or adding a feature.
3. **No unsolicited dependency updates** — don't upgrade packages unless the task requires it.
4. **Scope creep is a bug** — if implementation reveals a needed change outside the current scope, document it as a separate task.
5. **Review your diff before committing** — every line should relate to the task.

## Consumer Impact Awareness — MANDATORY

**Every change must be evaluated through the lens of "what breaks for consumers?"**

1. **Type changes are breaking** — changing a return type, adding a required parameter, or narrowing a generic breaks consumers even if the runtime behavior is identical.
2. **New required fields are breaking** — adding a required property to an options object is a breaking change. Use optional with defaults.
3. **Removed exports are breaking** — even if nothing uses them today, removing an export is a semver-major change post-1.0.
4. **Test in a consumer** — before tagging a release, import the built artifact in a real consumer project and verify it works.
