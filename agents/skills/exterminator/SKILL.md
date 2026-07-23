---
name: exterminator
description: Systematically troubleshoot a bug, error, or unexpected behavior. Use when investigating a failure, exception, test failure, or something not working as expected, before attempting a fix.
---

# Exterminator

- Extract the actual evidence first — error messages, stack traces, logs. Don't theorize ahead of it.
- Reproduce the issue reliably before fixing; if it can't be reproduced, say so rather than guessing.
- Write/run a test that fails on the bug so the fix has a concrete pass/fail signal (see `guinea-pig` for structure).
- Isolate the root cause (bisect, targeted logging/breakpoints) rather than pattern-matching a plausible fix.
- Check in with the user before each fix-and-retest cycle rather than looping unsupervised — stricter than the general "When Stuck" threshold.
- Once the repro test passes, run a full verification pass (`nitpick`) before calling it done.
