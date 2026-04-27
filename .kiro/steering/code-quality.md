---
inclusion: always
---

# Code Quality

Commenting standards, error handling, and design principles for shared libraries.

## Code Comments - MANDATORY

Every file must be understandable by a developer or AI agent with zero prior context.

### Module-Level

Every file starts with a docstring/JSDoc:
1. One-line summary of the module's purpose
2. How it fits into the library's architecture
3. Key design decisions or tradeoffs

### Functions and Methods

Every exported function has a docstring:
1. What it does and when to call it
2. Parameters with types and constraints
3. Return value and conditions
4. Thrown errors
5. Side effects (if any)

### Inline Comments

Use for:
- Non-obvious design decisions and reasoning
- Security rationale
- Performance tradeoffs
- Workarounds with issue references

Do NOT use for:
- Restating what the code does
- Obvious variable assignments

## Error Handling - MANDATORY

1. **Never silently swallow errors** - no empty `catch {}` blocks
2. **Throw typed errors** - not generic `Error("something went wrong")`
3. **Document thrown errors** in function docstrings
4. **Fail fast** - validate inputs at the boundary, not deep inside
5. **Errors must include context** - what operation, what input, what went wrong

## Design Principles - MANDATORY

1. **Pure functions by default** - no side effects, no hidden state
2. **Composition over inheritance** - no class hierarchies unless semantically justified
3. **Parameterize, don't specialize** - accept variations as parameters
4. **No god modules** - each file has one responsibility
5. **Explicit over implicit** - no magic, no hidden coupling
6. **Adapter pattern for extensibility** - when supporting multiple backends/providers, define an interface and ship implementations

### Adapter Pattern

```typescript
// Interface in the lib
interface StorageAdapter {
  save(key: string, data: unknown): Promise<void>;
  load(key: string): Promise<unknown>;
}

// Default implementation shipped with lib
class LocalStorageAdapter implements StorageAdapter { ... }

// Consumer provides custom implementation
const engine = createEngine({ storage: new MyCustomAdapter() });
```

Rules:
- Define the interface in the lib
- Ship at least one default implementation
- Consumer can provide custom implementations
- The lib never imports a specific implementation directly
