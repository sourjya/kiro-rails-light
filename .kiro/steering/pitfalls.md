---
inclusion: always
---

# Shared Library Pitfalls

Common traps and anti-patterns specific to shared libraries. Read this before building.

## The "Kitchen Sink" Trap

Don't add features speculatively. If only one consumer needs it, it belongs
in that consumer. Graduate to shared only when a second consumer needs the
same thing. A shared lib with 50 exports that 3 consumers each use 5 of
is worse than 3 focused libs.

## The "Leaky Abstraction" Trap

Don't expose internal state or implementation details. If you change the
internal data structure, consumers should not need to update their code.
Test this: can you refactor the internals without changing `index.ts` exports?

## The "Version Drift" Trap

When you update a shared lib, test it in ALL consumers before tagging.
A change that works in Project A might break Project B. Run the consumer's
test suite with the updated lib before releasing.

## The "Phantom Dependency" Trap

Don't rely on packages that happen to be in the consumer's node_modules.
If the lib needs a package, declare it in `dependencies` or `peerDependencies`.
A lib that works in Project A but fails in Project B because Project B doesn't
have `lodash` installed is a phantom dependency bug.

## The "React Version Coupling" Trap

Use `>=18.0.0` for React peer dep, not `^19.0.0`. Let consumers control
their React version. Test with the oldest supported version.

## The "Barrel File Bloat" Trap

`index.ts` should re-export, not contain logic. Keep it as a manifest
of public API. If `index.ts` has more than 30 lines, something is wrong.

## The "Shared State" Trap

Singleton state (module-level variables) in a shared lib is dangerous.
If two consumers import the same lib in the same process (e.g., during
testing), they share state unexpectedly. Prefer passing state via
function parameters or React context.

Exception: registries (like a keyboard shortcut registry) are
acceptable singletons when the design requires global coordination.
Document the singleton behavior explicitly.

## The "Over-Abstraction" Trap

If making something generic requires more than 3 domain-specific parameters,
it's not ready to be shared. Keep it in the consumer. A shared lib that's
harder to use than writing the code yourself has negative value.

## The "Missing README" Trap

A shared lib without a README is invisible. Every lib needs:
1. One-paragraph description
2. Quick start code example
3. API table (export, type, description)
4. Install instructions (both dev and prod paths)
5. Build/test commands

If a new developer can't use the lib in 5 minutes from the README alone,
the README is incomplete.

## The "Test in Isolation Only" Trap

Unit tests in the lib are necessary but not sufficient. Always test the
lib as a dependency in a real consumer project before releasing. Import
it, use the API, verify it works in the consumer's build pipeline.
