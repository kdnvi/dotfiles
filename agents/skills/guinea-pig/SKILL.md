---
name: guinea-pig
description: Write tests (test-first/TDD for risky changes) and manually sanity-check behavior for new logic or bug fixes. Use when adding non-trivial code that needs test coverage, or to confirm a change works beyond passing unit tests.
---

# Guinea Pig

- Follow the project's existing test framework, structure, and naming — don't introduce a new pattern.
- Focus coverage on logic that must not break; tests don't need to be exhaustive.
- Cover actual behavior/edge cases, not just the happy path.
- Beyond unit tests, manually sanity-check when feasible — run the CLI, hit the endpoint, exercise the UI flow.

## Test-first (TDD), when it's worth it
- Write the failing test before the implementation for: new logic/features/behavior, new edge cases, changes to existing functionality, or anything risking existing behavior. Then implement just enough to pass.
- Skip test-first ceremony for trivial/mechanical changes (config, renames, docs) — focus on what matters, not coverage.

Also useful for `exterminator`'s bug-repro test and `nitpick`'s test run; invoke directly with `/guinea-pig` any time.
