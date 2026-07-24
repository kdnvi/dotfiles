---
name: sherlock
description: Ground claims, APIs, or codebase behavior in primary sources before acting or deciding. Auto-triggers when work depends on getting a fact right — e.g. checking a library's actual behavior, a pinned dependency's API/version, or how existing code works before relying on it.
---

# Sherlock

- Trigger: an upcoming decision, trade-off, API call, or codebase behavior you're about to rely on for actual work. If the user directly asks you a question, answer it — don't redirect them elsewhere.
- First check `~/work/notes/plans/` for an existing design doc covering the topic (and `~/work/notes/research/` for prior findings). Before reusing a hit, sanity-check it's still current — compare its date/claims against the actual code, pinned versions, or docs it references. Reuse/cite what still holds; re-research anything stale or missing.
- Go to primary sources — official docs, source code, specs, first-party APIs — never secondary write-ups. Trace claims back to the source that owns them.
- Search as broadly as the question needs — codebase, docs, similar projects, RFCs — don't stop at the first source found.
- In this codebase: read the relevant files, callers, and tests before editing; match the version actually pinned (lockfile/manifest), not the latest release.
- Synthesize, don't dump — state what the findings mean, what's still unclear, and what follow-up questions they raise. If sources disagree, say so instead of silently picking one.
- Still unsure after checking primary sources? Ask the user — never guess (see "Decisions").
- Feeds into `whiteboard`'s trade-off discussion; invoke with `/sherlock` any time a decision needs grounding.

## Example
- Good: starting research on a topic → check `~/work/notes/plans/` and `~/work/notes/research/` first; found a matching design doc → verify its claims still match current code/versions, then cite it and only research what it doesn't cover.
- Bad: finding an old design doc and citing it as-is without checking whether the code/dependency it describes has since changed.
- Good: "Does this endpoint retry on timeout?" → read the client code and its tests, not a blog post about the library in general.
- Good: "Can we use `structuredClone` here?" → check the pinned Node/browser version in the manifest, then MDN/the spec for that version — not "latest" docs.
- Good: user asks "How do REST APIs usually handle retries?" → still investigate (docs, specs, or a web search) and answer with what you found — don't answer from unchecked memory just because it sounds casual.
- Bad: answering "does this library retry on 429s?" from memory of an older version instead of checking the pinned version's actual source/docs.

## Findings log
For research feeding a non-trivial decision or design, also log it to `~/work/notes/research/<snake_case_slug>.md` (prefix a ticket ID if one exists, e.g. `TICKET-123_slug.md`). Skip for quick one-off lookups. On revisiting the same question, append to the existing file — don't create a new one.

Template:

```
Date: YYYY-MM-DD

# <Question or claim being grounded>

## Findings
What the sources show, in plain terms.

## Sources
- <source> — <url or file path> — what it confirms/refutes.

## Unclear / disagreements
Anything sources didn't resolve or conflicted on (skip if none).
```

Point `whiteboard` at this file instead of re-pasting findings into the design doc.
