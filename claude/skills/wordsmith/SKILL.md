---
name: wordsmith
description: Compose human-facing documentation — READMEs, guides, changelogs, release notes, customer-facing docs, and internal engineering docs (runbooks, architecture notes, onboarding). Use only when explicitly asked, as the final step after the work is done and approved.
---

# Wordsmith

- Trigger: the work is done, the user has explicitly approved it, and they've explicitly asked for docs — never write docs proactively or pre-emptively.
- Structure, tone, and detail should suit docs meant for people — not code comments, not the design doc.
- Match the audience: customer-facing docs stay free of internal jargon and implementation detail, framed around what the reader can do or expects; engineering docs (runbooks, architecture notes, onboarding) can assume technical context and go into internals.

## Example
- Good: user says "looks good, update the README" after a merge-ready change → write the README section now.
- Good: user approves the code and separately asks for a CHANGELOG entry → write in a tone/format suited to that changelog, not a copy of the design doc.
- Good: user asks for release notes for the new feature → write for the customer, describing what changed for them, not the internal implementation.
- Good: user asks for a runbook after shipping a new service → write for an on-call engineer, assuming technical context and covering internals the customer-facing docs wouldn't.
- Bad: adding a "Usage" section to the README mid-feature, before the user asked or approved.
- Bad: writing customer-facing release notes with internal function/module names instead of user-visible behavior.
