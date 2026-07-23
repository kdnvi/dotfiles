---
name: tailor
description: Reference for writing or reviewing my own skill files (SKILL.md, CLAUDE.md) so they stay predictable and lean. Manual-invocation-only — invoke with /tailor.
disable-model-invocation: true
---

# Tailor

A skill exists to make the agent take the same *process* every run. Every rule below serves that.

- Trigger: manual-only, invoked with `/tailor` before creating or editing a skill file.
- **No duplication.** Say each rule in exactly one place; point other files at it instead of restating it.
- **Reuse one strong word per concept.** Pick a single evocative term for a recurring idea (a "tight" feedback loop, a test that goes "red") and repeat it through the skill's body instead of re-describing the idea each time — cheaper in tokens and gives the agent one consistent hook to reason with.
- **No no-ops.** Before adding a line, ask: does this change behavior versus what the agent would already do? If not, cut it — it's just cost with no effect.
- **Positive over negation.** State the target behavior, not the banned one — "ask one question at a time" beats "don't ask multiple questions." Keep a flat prohibition only when there's no positive phrasing that covers it, and pair it with what to do instead.
- **Checkable completion.** Every step should have a condition the agent can tell done from not-done by — "tests green, diff reviewed, nothing outstanding," not "looks good."
- **Push detail out, keep triggers in.** `SKILL.md` should read fully on every load; move templates/long reference material to a linked file only if the skill needs one.
- **Trivial and reversible only.** A skill deciding something itself (not asking) is only ever justified when it's both — see "Decisions".

## Invocation
Model-invoked (auto-triggers) vs. manual-only (`disable-model-invocation: true`): pick manual-only when the skill should only ever fire by you typing it, so its description carries zero always-loaded context cost. Model-invoked earns its cost only when the agent must find it unprompted.
