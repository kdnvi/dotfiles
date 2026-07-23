---
name: ghostwriter
description: Compose human-facing documentation (README, guides, changelogs). Use only when explicitly asked, as the final step after the work is done and approved.
---

# Ghostwriter

- Trigger: the work is done, the user has explicitly approved it, and they've explicitly asked for docs — never write docs proactively or pre-emptively.
- Structure, tone, and detail should suit docs meant for people — not code comments, not the design doc.

## Example
- Good: user says "looks good, update the README" after a merge-ready change → write the README section now.
- Good: user approves the code and separately asks for a CHANGELOG entry → write in a tone/format suited to that changelog, not a copy of the design doc.
- Bad: adding a "Usage" section to the README mid-feature, before the user asked or approved.
