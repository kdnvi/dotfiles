---
name: whiteboard
description: Weigh trade-offs and design an approach before implementing non-trivial or multi-step work. Use when a task involves multiple valid approaches, a new dependency, a major version upgrade, a breaking change to a public API/database schema/config format, or when presenting a plan for a task with more than a couple of steps.
---

# Whiteboard

- Trigger: a choice with real trade-offs — architecture, performance, compatibility, maintenance, a new dependency/major upgrade, or a breaking change to a public API/schema/config. Ask before proceeding (see "Decisions" — this is never a trivial-and-reversible case).
- Present every option with its pros/cons; never pick a non-trivial option unilaterally.
- Prefer a library already used in the project over introducing a new one, unless you state a specific reason not to.
- Surface open questions and alternatives, and iterate with the user until they give an explicit final decision — a single unconfirmed proposal is not a decision.
- Ground claims and scout alternatives with `sherlock` (`/sherlock`) instead of guessing or settling for the first idea.

## Example
- Good: "Add caching" → present Redis vs in-memory vs on-disk with pros/cons, ask which fits before writing code.
- Good: "Upgrade React 17 → 19" is a major upgrade with breaking changes → surface the migration risks and ask before starting, even if the user just said "upgrade React."
- Skip: renaming a local variable, fixing a typo — trivial and reversible (see "Decisions"), just do it.

## Design doc
For non-trivial multi-step work, also write it to `~/work/notes/plans/<snake_case_slug>.md` (prefix a ticket ID if one exists, e.g. `TICKET-123_slug.md`). Skip for trivial one-off asks. On revision, edit the existing file — don't create a new one. Link to `sherlock`'s findings log (`~/work/notes/research/`) instead of re-pasting its findings here.

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
