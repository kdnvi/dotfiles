---
name: guinea-pig
description: Write tests (test-first/TDD for risky changes) and manually sanity-check behavior for new logic or bug fixes. Use when adding non-trivial code that needs test coverage (e.g. "add tests for X", a new feature, a new edge case), or to confirm a change works beyond passing unit tests.
---

# Guinea Pig

- Trigger: adding non-trivial new logic or a bug fix that needs test coverage, or confirming a change works beyond just passing unit tests.
- Follow the project's existing test framework, structure, and naming — don't introduce a new pattern.
- When there's more than one plausible interface to test against (e.g. a new module with no established pattern), confirm which one before writing tests — an unconfirmed interface risks tests that don't survive review (see "Decisions").
- Focus coverage on logic that must not break; tests don't need to be exhaustive.
- Cover actual behavior/edge cases, not just the happy path.
- Beyond unit tests, manually sanity-check any change that's user-facing or externally observable — run the CLI, hit the endpoint, exercise the UI flow yourself, don't rely on unit tests alone.

## TDD criteria — decide at Build start
Applies (write the failing test first, then implement just enough to pass) if the change is any of:
- New logic, feature, or behavior.
- A new edge case for existing behavior.
- A change to existing functionality.
- Anything that risks breaking existing behavior.

Skip test-first ceremony for trivial/mechanical changes (config, renames, docs) — write tests after, if at all, and focus on what matters, not coverage for its own sake.

Also useful for `sleuth`'s bug-repro test and `gatekeeper`'s test run; invoke directly with `/guinea-pig` any time.

## Example
- Good: adding a `discount()` function → write a failing test for the 10%-off case first, then implement until it passes.
- Good: changing existing `parseDate()` to accept a new format → write a failing test for the new format before touching the parser, so the old formats' tests catch any regression.
- Skip: renaming a function or updating a config value — no test-first ceremony needed.
