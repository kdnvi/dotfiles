---
name: guinea-pig
description: Write tests and manually sanity-check behavior for new logic or bug fixes. Use when adding non-trivial code that needs test coverage, or to confirm a change actually works beyond passing existing tests.
---

# Guinea Pig

- Follow the project's existing test framework, structure, and naming conventions rather than introducing a new pattern.
- Focus coverage on important logic that must not break — tests don't need to be exhaustive.
- Write tests alongside non-trivial new logic or bug fixes, covering the actual behavior/edge cases, not just the happy path.
- Beside unit tests, manually sanity-check the actual behavior when feasible — run the CLI command, hit the API endpoint, exercise the UI flow — to confirm it works in practice, not just that unit tests pass in isolation.

## Related
These conventions are also useful for `exterminator`'s narrow bug-reproduction test, and `nitpick` runs whatever tests exist afterward — invoke this skill directly with `/guinea-pig` any time it's useful on its own.
