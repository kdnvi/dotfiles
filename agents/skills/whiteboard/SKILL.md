---
name: whiteboard
description: Weigh trade-offs and design an approach before implementing non-trivial or multi-step work. Use when a task involves multiple valid approaches, a new dependency, a major version upgrade, a breaking change to a public API/database schema/config format, or when presenting a plan for a task with more than a couple of steps.
---

# Whiteboard

- Ask before proceeding on choices with real trade-offs: architecture, performance, compatibility, maintenance, new dependencies/major upgrades, breaking changes to public APIs/schemas/config.
- Skip approval for obvious, low-risk choices (variable names, typos, following an existing pattern).
- Present options with pros/cons rather than picking unilaterally; if deciding without asking, explain the reasoning.
- Prefer libraries already used in the project over new ones.
- Discuss, don't assume — surface open questions and alternatives, iterate with the user to an explicit final decision, not a one-shot proposal.
- Ground claims and scout alternatives with `sherlock` (`/sherlock`) rather than guessing or settling for the first idea.

## Design doc
For non-trivial multi-step work, also write it to `~/work/notes/plans/<snake_case_slug>.md` (prefix a ticket ID if one exists, e.g. `TICKET-123_slug.md`). Skip for trivial one-off asks. On revision, edit the existing file — don't create a new one.

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
Other approaches and why they were not chosen (skip if there was only one reasonable approach).

## Risks / Trade-offs
Anything that could break, be slow, or need a follow-up.

## Open Questions
Anything unresolved that needs a decision before/during implementation.
```
