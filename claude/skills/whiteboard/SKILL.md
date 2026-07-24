---
name: whiteboard
description: Weigh trade-offs and design an approach before implementing non-trivial or multi-step work. Use when a task involves multiple valid approaches, a new dependency, a major version upgrade, a breaking change to a public API/database schema/config format, or when presenting a plan for a task with more than a couple of steps.
---

# Whiteboard

- Trigger: a choice with real trade-offs — architecture, performance, compatibility, maintenance, a new dependency/major upgrade, or a breaking change to a public API/schema/config. Ask before proceeding (see "Decisions" — this is never a trivial-and-reversible case).
- Always work in Plan Mode — its read-only guarantee matches designing before touching code. Propose switching to it first if it isn't already active; clarification and design for a trade-off decision happen here, not in `sherlock` or anywhere else.
- Present every option with its pros/cons; never pick a non-trivial option unilaterally.
- Prefer a library already used in the project over introducing a new one, unless you state a specific reason not to.
- Surface open questions and alternatives, and iterate with the user until they give an explicit final decision — a single unconfirmed proposal is not a decision.
- Ground claims and scout alternatives directly with the `mycroft`/`watson` subagents instead of guessing or settling for the first idea — you're in Plan Mode already, no need to route back through `sherlock`. Every claim the design doc's Approach/Risks rests on must trace back to a findings-log entry — if it doesn't exist yet, delegate first. `mycroft` can't write files, so you save its returned write-up (see `mycroft`'s "Reporting back") to the log yourself.

## Example
- Good: "Add caching" → present Redis vs in-memory vs on-disk with pros/cons, ask which fits before writing code.
- Good: "Upgrade React 17 → 19" is a major upgrade with breaking changes → surface the migration risks and ask before starting, even if the user just said "upgrade React."
- Skip: renaming a local variable, fixing a typo — trivial and reversible (see "Decisions"), just do it.
- Good: `sherlock`'s research turns up a real trade-off (e.g. two viable libraries) → `sherlock` hands off here instead of picking one; propose switching to Plan Mode if it isn't active, then run the trade-off discussion.

## Design doc
Always write it to `~/work/notes/plans/<snake_case_slug>.md` — no other location (prefix a ticket ID if one exists, e.g. `TICKET-123_slug.md`). On revision, edit the existing file — don't create a new one. Cite the findings log (`~/work/notes/research/`) by file/entry wherever the design relies on it, instead of re-pasting or re-asserting the findings here.

Template:

```
Date: YYYY-MM-DD

# <Title>

## Goal
What outcome this achieves and why it's needed.

## Context
Relevant background, constraints, existing code/systems involved.

## Approach
The proposed steps/design, in the order they'd be executed.

## Alternatives Considered
Other approaches and why they were not chosen (skip only if no other approach was viable).

## Risks / Trade-offs
Anything that could break, be slow, or need a follow-up.

## Open Questions
Anything unresolved that needs a decision before/during implementation.
```
