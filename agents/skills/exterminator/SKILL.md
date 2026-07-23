---
name: exterminator
description: Systematically troubleshoot a bug, error, or unexpected behavior. Use when investigating a failure, exception, test failure, or something not working as expected, before attempting a fix.
---

# Exterminator

- Read and extract the actual evidence first — error messages, stack traces, logs — don't theorize ahead of the evidence.
- Reproduce the issue reliably before attempting a fix; if it can't be reproduced, say so rather than guessing at a cause.
- Write or run a test that fails on the bug (captures/challenges the exact case), so the fix has a concrete pass/fail signal instead of "looks right" — `guinea-pig`'s conventions are a useful reference for how it's structured.
- Isolate the root cause (bisect, add targeted logging/breakpoints) rather than pattern-matching a plausible-looking fix.
- Once the reproduction test passes, a full verification pass (see `nitpick`) is a good next step before calling it done.
