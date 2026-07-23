---
name: nitpick
description: Run tests/linters and do a final self-check before declaring a task done. Use after making a non-trivial code change, and right before telling the user the task is complete.
---

# Nitpick

## Verify
- Run relevant tests/linters when the project has them; report what ran and the result — don't assume changes work without verification.
- If tests are missing for non-trivial new logic, consider `guinea-pig` for writing them rather than skipping straight to done — invoke it directly with `/guinea-pig` if useful.

## Final self-check
Before telling the user a task is complete:
- Re-read the diff against the original request — nothing missed, nothing unrelated changed.
- Check for leftover debug code or TODOs.
- Confirm no workflow rule (scope, generated files, secrets, git) was violated.
- If anything is incomplete or uncertain, say so instead of declaring done.
