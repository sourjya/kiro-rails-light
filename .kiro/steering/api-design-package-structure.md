---
inclusion: always
---

# API Design and Package Structure

Rules for shared library public API, package layout, and consumer integration.

## Public API - MANDATORY

**Every export is a maintenance commitment. The public API is the contract.**

### Rules

1. **Single entry point** - `src/index.ts` (or `src/__init__.py`) is the only public API. All exports go through it. Consumers never import from internal paths.
2. **Minimal surface area** - export only what consumers need. Internal helpers stay unexported.
3. **Types are part of the API** - every exported function, hook, and component has explicit types. No `any`. No implicit returns.
4. **Zero side effects on import** - importing the lib must not execute code, register globals, or modify state.
5. **Headless over opinionated** - provide logic, not UI. Consumers bring their own design system.
6. **Configuration over convention** - accept behavior as parameters. The lib doesn't know which product is using it.

## Breaking Changes

A breaking change is any change that requires consumers to modify their code.

**Before making a breaking change:**
1. Can it be a new function alongside the old one?
2. Can the old signature be preserved with a deprecation warning?
3. If it must break: bump MINOR (pre-1.0) or MAJOR (post-1.0), document in CHANGELOG.

## Package Structure - MANDATORY

```
{lib-name}/
├── .gitignore                node_modules/, dist/, *.log, .DS_Store
├── package.json              name, version, author, license, peer deps
├── tsconfig.json             strict, declaration, rootDir: ./src
├── vite.config.ts            library mode, externalize peer deps
├── vitest.config.ts          jsdom if React hooks, node otherwise
├── README.md                 quick start, API table, install instructions
├── CHANGELOG.md              release history (Keep a Changelog format)
├── src/
│   ├── index.ts              single public entry point
│   ├── types.ts              public type definitions
│   └── {modules}.ts          implementation files
└── tests/
    └── {module}.test.ts      one test file per source file
```

### What does NOT belong

- `.kiro/specs/` - specs live in the consuming project
- `docs/` directory - README.md is sufficient for libs this size
- Consumer-specific config or references to specific products
- `dist/` in git - always gitignored, built on install

## Dependency Discipline - MANDATORY

1. **Zero runtime dependencies** if possible. Self-contained libs.
2. **Peer deps for frameworks** - React, FastAPI, etc. Never bundled.
3. **Dev deps only for tooling** - TypeScript, Vite, Vitest, testing-library.
4. **Justify every dependency** - if stdlib or 20 lines can do it, don't add a package.
5. **Audit before adding** - check maintenance, downloads, last update, vulnerabilities.
6. **No phantom dependencies** - don't rely on packages in the consumer's node_modules.

### Ideal Profile

```json
{
  "peerDependencies": { "react": ">=18.0.0" },
  "dependencies": {},
  "devDependencies": { "typescript": "~6.0.0", "vite": "^8.0.0", "vitest": "^4.0.0" }
}
```

## Consumer Integration (ADR-008)

**Dev:** `"lib-name": "file:../../shared-libs/lib-name"`
**Prod:** `"lib-name": "git+ssh://git@github.com:ChaosLabz/lib-name.git#v0.1.0"`

The lib must work from both paths. Test with a real consumer before tagging.
