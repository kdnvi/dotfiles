---
name: sherlock
description: Ground claims, APIs, or codebase behavior in primary sources before acting, deciding, or presenting trade-offs on actual work. Auto-triggers when real work depends on getting a fact right — not for casual learning (use rabbithole for that).
---

# Sherlock

## When to actually use this
For actual work only — a decision, a trade-off, an API you're about to call, codebase behavior you're about to rely on. Skip it for casual "how does X work" curiosity that isn't blocking a decision — that's `rabbithole`.

## Scout
- Investigate against primary sources — official docs, source code, specs, first-party APIs — not a secondary write-up of them.
- Follow every claim back to the source that owns it.
- Pull from whatever sources the question actually needs — codebase, official docs, similar projects, specs/RFCs — not just the first one that comes to mind.
- When it's about this codebase: read the relevant source files, callers, and tests before editing, and match the version actually used in the project (CMakeLists.txt/Makefile, pom.xml/build.gradle, requirements.txt/pyproject.toml, package.json, go.mod, etc.) rather than assuming latest.

## Brainstorm on findings
- Don't just dump facts — synthesize them: what they mean, what's still unclear, what follow-up questions they raise.
- Surface disagreements or gaps between sources instead of picking one silently.

## When still unsure
Ask the user rather than guessing.

## Related
Feeds directly into `whiteboard`'s trade-off/alternatives discussion — invoke with `/sherlock` any time a real decision needs grounding, even outside planning.
