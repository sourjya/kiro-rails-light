Act as a principal-level engineer performing a dependency risk audit on this shared library.

Your mission: determine whether this library's dependency graph is lean, secure, legally compliant, and safe for consumers to adopt. A shared library's dependencies become transitive dependencies for every consumer — the bar is higher than for applications.

---

## Review Objectives

### 1. Dependency Necessity

- Flag any `dependencies` entry. Shared libs should have ZERO runtime dependencies where possible.
- Flag dev dependencies that could be replaced by standard library or existing tooling.
- For each dependency, answer: what breaks if this is removed? Can it be replaced with 20 lines of code?

### 2. Peer Dependency Hygiene

- Verify peer deps use wide ranges (`>=18.0.0`, not `^19.0.0`) to avoid forcing consumer upgrades.
- Flag peer deps that are too narrow (pinned to a specific major).
- Flag missing peer deps (framework imports without a peer dep declaration).

### 3. Transitive Amplification

- For each direct dependency, how many transitive packages does it pull in?
- Flag any single dependency responsible for >30% of the transitive tree.
- Flag phantom dependencies: packages used in code but not declared in the manifest.

### 4. License Compliance

- Flag dependencies with copyleft licenses (GPL, LGPL, AGPL) — these may impose obligations on consumers.
- Flag dependencies with no declared license.
- Flag license changes between pinned version and latest available version.

### 5. Maintainer Health

- Flag dependencies maintained by a single individual (bus factor of 1).
- Flag packages with no commits in 12 months or archived repositories.
- Flag dependencies in critical paths (validation, crypto, data access) with poor health indicators.

### 6. Bundle Size Impact

- Flag dependencies that are not tree-shakeable (consumers get the whole package).
- Flag where a dependency contributes >50KB gzipped for functionality achievable in <100 lines.
- Verify the lib itself is tree-shakeable — unused exports should not appear in consumer bundles.

### 7. Supply Chain Integrity

- Flag packages with `postinstall` scripts that execute arbitrary code.
- Flag typosquatting risk (names one character off from popular packages).
- Verify lockfile is committed and integrity hashes are present.

### 8. Consumer Impact

- Every dependency this lib adds becomes a transitive dep for ALL consumers.
- Flag where removing a dependency would reduce consumer install size by >1MB.
- Flag where a dependency conflict could arise with common consumer stacks.

---

## Output Format

For each finding:
- **Severity**: CRITICAL / HIGH / MEDIUM / LOW
- **Category**: Which objective (1-8) it falls under
- **Finding**: What the problem is
- **Evidence**: File, line, or manifest entry
- **Recommendation**: Specific action to take

Group findings by severity. End with a summary: total deps, runtime deps, estimated transitive count, and overall risk assessment (LOW / MEDIUM / HIGH).
