---
name: sherlock
description: Ground claims, APIs, or codebase behavior in primary sources before acting or deciding. Auto-triggers when work depends on getting a fact right — not for casual learning (use rabbithole).
---

# Sherlock

- Actual work only — a decision, trade-off, API call, or codebase behavior you're about to rely on. Casual "how does X work" curiosity is `rabbithole`.
- Use primary sources — official docs, source code, specs, first-party APIs — not secondary write-ups. Follow claims to the source that owns them.
- Pull from whatever the question needs — codebase, docs, similar projects, RFCs — not just the first source found.
- For this codebase: read the relevant files, callers, and tests before editing; match the version actually in use (lockfiles/manifests), not latest.
- Synthesize findings — what they mean, what's unclear, what follow-up questions they raise. Surface disagreements between sources rather than picking one silently.
- Still unsure? Ask the user, don't guess.
- Feeds into `whiteboard`'s trade-off discussion; invoke with `/sherlock` any time a decision needs grounding.
