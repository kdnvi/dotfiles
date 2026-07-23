---
name: exterminator
description: Systematically troubleshoot a bug, error, or unexpected behavior. Use when investigating a failure, exception, test failure, or something not working as expected, before attempting a fix.
---

# Exterminator

- Trigger: a bug, error, exception, or failing test — before attempting any fix.
- Collect the actual evidence first — error messages, stack traces, logs. Don't theorize ahead of it.
- Reproduce the issue reliably before fixing; if it can't be reproduced, say so rather than guessing at a cause.
- Write/run a test that fails on the bug so the fix has a concrete pass/fail signal (see `guinea-pig` for structure).
- Generate 2-3 falsifiable hypotheses for the root cause before testing any of them, ranked by likelihood — testing only the first plausible idea invites anchoring. State each as a prediction: "if X is the cause, then Y should happen."
- Isolate the root cause via bisecting or targeted logging/breakpoints, testing hypotheses in ranked order — don't pattern-match a plausible-looking fix. Tag any debug logging with a unique prefix (e.g. `[DEBUG-a1b2]`) so removing it later is one grep, not a vibe-check.
- Check in with the user before each fix-and-retest cycle instead of looping unsupervised — stricter than the general "When Stuck" threshold.
- Once the repro test passes, confirm the debug-tag grep is empty, then run a full verification pass (`nitpick`) before calling it done.

## Example
- Good: "500 on checkout" → pull the stack trace, reproduce locally, write a test that fails on the exact error, rank a few hypotheses, bisect/instrument to test them in order, fix, confirm the test passes, then `nitpick`.
- Good: "This started failing after a recent change" → bisect across recent commits to find the one that introduced it before touching any code.
- Bad: seeing a `TypeError` in the logs and guessing a fix without reproducing it first.
- Bad: instrumenting the first idea that comes to mind instead of ranking a few hypotheses first.
