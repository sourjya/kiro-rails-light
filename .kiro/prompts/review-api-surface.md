Act as a principal-level library architect performing a public API surface audit on this shared library.

Your mission: determine whether the library's public API is minimal, consistent, well-typed, and safe to evolve. Every export is a maintenance commitment — an API that works today but cannot be changed without breaking unknown consumers is a liability.

---

## Review Objectives

### 1. Surface Area Minimalism

- Flag exports that are not used by any known consumer.
- Flag internal helpers that are accidentally exported (missing `@internal` or not re-exported from index).
- Flag where the public API could be reduced without losing functionality (e.g., two functions that could be one with an options parameter).
- Verify `src/index.ts` (or equivalent) is the single entry point — no deep imports from internal paths.

### 2. Type Safety and Completeness

- Every exported function must have explicit parameter types and return types (no `any`, no implicit).
- Flag functions that accept `any` or return `any` — consumers lose type safety.
- Flag missing generic constraints that would catch misuse at compile time.
- Verify all exported types are actually exported (not just used internally).
- Flag where TypeScript's `strict` mode would catch issues that the current config misses.

### 3. API Consistency

- Flag inconsistent naming patterns across exports (e.g., `createFoo` vs `makeFoo` vs `buildFoo`).
- Flag inconsistent parameter ordering (e.g., some functions take `options` first, others last).
- Flag inconsistent return shapes (e.g., some return `T | null`, others return `T | undefined`, others throw).
- Verify error handling is consistent: does the lib throw, return errors, or use Result types? It should be one pattern.

### 4. Options Object Pattern

- Functions with >2 parameters should use an options object.
- Flag positional parameters that are booleans (unclear at call site).
- Verify options objects have sensible defaults — consumers shouldn't need to pass every field.
- Flag required fields in options objects that could be optional with defaults.

### 5. Breaking Change Risk

- Flag any export where a minor change (adding a field, changing a default) would break consumers.
- Flag union types that consumers might be exhaustively matching — adding a variant is breaking.
- Flag where the API design makes future extension difficult without breaking changes.
- Verify that the current API could add features via new optional fields or new functions without touching existing signatures.

### 6. Side Effects and Purity

- Flag exports that have side effects on import (module-level code that executes).
- Flag functions that mutate their arguments instead of returning new values.
- Flag hidden state (module-level singletons) that could cause issues when multiple consumers share the same instance.
- Verify that the lib can be imported without triggering network calls, DOM access, or global registration.

### 7. Documentation Completeness

- Every export must have a JSDoc/docstring with: purpose, parameters, return value, thrown errors.
- Flag exports with no documentation or with stale/incorrect documentation.
- Flag where the README's API table is out of sync with actual exports.
- Verify code examples in README actually work with the current API.

### 8. Consumer Ergonomics

- Can a consumer use the most common use case in ≤3 lines of code?
- Flag where the API requires boilerplate that could be handled by sensible defaults.
- Flag where error messages don't help the consumer fix the problem.
- Verify that TypeScript autocomplete provides useful information (good type names, JSDoc visible).

---

## Output Format

For each finding:
- **Severity**: CRITICAL / HIGH / MEDIUM / LOW
- **Category**: Which objective (1-8) it falls under
- **Finding**: What the problem is
- **Evidence**: File, line, or export name
- **Recommendation**: Specific action to take

Group findings by severity. End with a summary: total exports (functions, types, constants), API consistency score (LOW / MEDIUM / HIGH), and evolution safety assessment (how safely can this API grow without breaking consumers).
