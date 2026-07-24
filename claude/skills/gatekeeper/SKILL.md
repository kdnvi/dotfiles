---
name: gatekeeper
description: Careful review gate — run tests/linters, critically review the diff, and loop back to fix rather than stop-and-report. Use right before declaring a non-trivial task done.
---

# Gatekeeper

- Trigger: right before declaring a non-trivial task done. Run every section below, in order, before saying so.

## 1. Confirm checks pass
- Run relevant tests/linters when the project has them; report what ran and the result.
- If tests are missing for non-trivial new logic, use `guinea-pig` (`/guinea-pig`) to write them rather than skipping to done.

## 2. Review the diff
- Read every changed line — check logic, edge cases, error handling, not just "does it run."
- Re-check against the original request/plan — nothing missed, nothing unrelated changed.
- Grep for any `[DEBUG-...]` tags left by `sleuth` (must be empty) and check for other dead code or TODOs.
- Confirm no workflow rule was violated.

## 3. Loop until it passes
- Found a real problem (bug, missed requirement, failing test, rule violation)? Report it to the user before fixing — never retry on your own.
- Consult the user on every loop, not just after repeated failures — stricter than "When Stuck", to avoid unsupervised fix-and-recheck cycles.
- Once the user agrees with the fix direction, go back to Build/Verify, fix it, and re-review from step 1.
- Only a clean pass (tests green, diff reviewed, nothing outstanding) counts as approved — a partial pass is not "done."
- Genuinely ambiguous or a trade-off, not a clear defect? Ask instead of guessing (see "Decisions").

## Example
- Good: diff review finds a missing null check → stop, report it, wait for direction, then fix and re-review from the top.
- Good: task touched a file that wasn't part of the original request → flag it as scope creep before approving, even if the change itself looks fine.
- Bad: silently patching a found bug and re-running tests without telling the user first.
