---
name: nitpick
description: Careful review gate — run tests/linters, critically review the diff, and loop back to fix rather than stop-and-report. Use right before declaring a non-trivial task done.
---

# Nitpick

## Verify
- Run relevant tests/linters when the project has them; report what ran and the result.
- If tests are missing for non-trivial new logic, use `guinea-pig` (`/guinea-pig`) to write them rather than skipping to done.

## Review the diff
- Read every changed line — check logic, edge cases, error handling, not just "does it run."
- Re-check against the original request/plan — nothing missed, nothing unrelated changed.
- Check for leftover debug code, dead code, or TODOs.
- Confirm no workflow rule (scope, generated files, secrets, git) was violated.

## Loop until it passes
- Found a real problem (bug, missed requirement, failing test, rule violation)? Report it to the user before fixing — don't retry on your own.
- Consult the user on every loop, not just after repeated failures — stricter than "When Stuck", to avoid unsupervised fix-and-recheck cycles.
- Once the user agrees with the fix direction, go back to Build/Verify, fix it, and re-review from the top.
- Only a clean pass (tests green, diff reviewed, nothing outstanding) counts as approved.
- Genuinely ambiguous or a trade-off, not a clear defect? Ask instead of guessing.
