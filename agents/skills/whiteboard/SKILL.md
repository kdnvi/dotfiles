---
name: whiteboard
description: Weigh trade-offs and design an approach before implementing non-trivial or multi-step work. Use when a task involves multiple valid approaches, a new dependency, a major version upgrade, a breaking change to a public API/database schema/config format, or when presenting a plan for a task with more than a couple of steps.
---

# Whiteboard

## Trade-off decisions
- Ask before proceeding on choices with meaningful trade-offs: architecture, performance, compatibility, maintenance, new dependencies or major upgrades, and breaking changes to public APIs, database schemas, or config formats other code depends on.
- Do not ask for approval on obvious, low-risk choices (naming a local variable, fixing a typo, following an existing pattern in the same file).
- When asking, present options briefly with pros/cons rather than picking unilaterally.
- When deciding without asking, always explain the reasoning behind the choice.
- Prefer libraries already used in the project over introducing new ones.

## Discuss before finalizing
- Actively discuss with the user rather than assuming — surface open questions, ambiguous requirements, and alternative approaches, and iterate with them until there's a complete picture and an explicit final decision (not just a one-shot proposal).
- Don't guess at facts or settle for the first idea that fits — use `sherlock` to ground claims and scout prior art/alternatives (comparable OSS projects, industry patterns, specs/RFCs) so the options presented reflect the broader landscape. Invoke it directly with `/sherlock` if it doesn't trigger automatically.

## Write the design doc
For non-trivial multi-step work, write a design doc and save it to `~/work/notes/plans/` (`mkdir -p` if missing), in addition to presenting it in chat. Skip this for trivial one-off asks.

- Path: `~/work/notes/plans/<snake_case_slug>.md`, e.g. `migrate_auth_service.md`. Prefix with a ticket ID if one exists: `<TICKET-123>_<snake_case_slug>.md`.
- On revision, edit the existing file — don't create a new one.

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
