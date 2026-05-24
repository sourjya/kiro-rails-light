---
inclusion: always
---

# Testing Standards

TDD discipline and test organization for shared libraries.

## Test-Driven Development - MANDATORY

1. **Write tests before implementation** - see the test fail first (RED)
2. **Write minimal code to pass** (GREEN)
3. **Refactor while green** (REFACTOR)
4. **No code without tests** - every exported function has tests

### Exceptions (no test required)

- Type definitions (`types.ts`)
- Re-export barrel files (`index.ts`)
- Configuration files (tsconfig, vite config)

## Test Organization - MANDATORY

```
tests/
├── validator.test.ts         ← mirrors src/validator.ts
├── conditionalLogic.test.ts  ← mirrors src/conditionalLogic.ts
├── useFormEngine.test.ts     ← .test.tsx if JSX needed
└── (flat structure, no subdirectories unless 20+ test files)
```

### Rules

1. **Tests live in `tests/`** - not co-located, not in `__tests__/`
2. **Test file mirrors source** - `src/foo.ts` → `tests/foo.test.ts`
3. **Use `.test.tsx` for JSX** - vitest/vite needs the extension for JSX parsing
4. **Both positive and negative cases** - test what works AND what should fail
5. **No mocking the lib's own code** - mock external deps only
6. **Tests must pass before commit** - no "fix tests later"

## Coverage Requirements

- **100% of exports** must have at least one test
- **Edge cases** for every validation function (empty, null, boundary values)
- **Error paths** for every function that can throw
- **Hook lifecycle** for React hooks (mount, update, unmount)

## Test Tooling

- **TypeScript libs:** Vitest + @testing-library/react (if React hooks)
- **Python libs:** pytest
- **Environment:** jsdom for browser APIs, node for pure logic

## Completion Verification — MANDATORY

**`tsc --noEmit` + `npm run build` passing is NECESSARY but NOT SUFFICIENT.**

Build tools verify types, imports, and syntax. They do NOT verify:
- Exported functions behave correctly with real inputs
- Default values produce sensible results (not empty/broken state)
- The lib works when imported as a dependency in a consumer project
- Edge cases are handled (null, empty arrays, missing optional fields)

### Rules

1. **Never declare work "done" based solely on build output** — tests must pass, and ideally the lib must be tested in a real consumer.
2. **Test with real-world inputs** — not just the happy path. Empty objects, null values, and boundary conditions are where libs break.
3. **Speculation is not verification** — "it should work" is not acceptable. If you haven't tested a code path, say so.
4. **Consumer smoke test before tagging** — before any release tag, import the built artifact in at least one real consumer and verify it works end-to-end.
