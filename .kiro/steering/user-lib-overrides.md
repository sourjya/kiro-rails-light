---
inclusion: always
---

# Library Overrides

Project-specific values for this shared library. This is the ONLY steering file you should edit.
All other steering files are managed by kiro-rails-light and will be overwritten on upgrade.

<!-- ──────────────────────────────────────────────
     INSTRUCTIONS:
     - Uncomment and fill in sections relevant to your library
     - Delete sections you don't need
     ────────────────────────────────────────────── -->

## Library Identity

<!-- Uncomment and set:
- **Name**: my-lib
- **Language**: TypeScript | Python
- **Purpose**: One-sentence description of what this lib does
-->

## Peer Dependencies

<!-- List framework dependencies consumers must provide:
- react >=18.0.0
- @tanstack/react-query >=5.0.0
-->

## Build Tool

<!-- Uncomment your build tool:
- **Vite** library mode (vite.config.ts with build.lib)
- **tsup** (tsup.config.ts)
- **tsc** only (tsconfig.json with declaration: true)
- **setuptools** / **hatch** / **flit** (pyproject.toml)
-->

## Test Runner

<!-- Uncomment your test runner:
- **Vitest** (vitest.config.ts)
- **Jest** (jest.config.ts)
- **pytest** (pyproject.toml [tool.pytest])
-->

## Exports Strategy

<!-- Describe your public API surface:
- Single entry point: src/index.ts
- Multiple entry points: src/index.ts + src/server.ts
- Subpath exports: package.json "exports" field
-->

## Consumer Integration

<!-- How consumers install this lib:
- Dev: "my-lib": "file:../../shared-libs/my-lib"
- Prod: "my-lib": "git+ssh://git@github.com:org/my-lib.git#v0.1.0"
- Registry: npm install @org/my-lib
-->

## Library-Specific Rules

<!-- Add any rules specific to this library:
- Example: All validators must return FieldError | null, never throw
- Example: Hooks must accept an options object, not positional args
- Example: All async functions must accept AbortSignal
-->
