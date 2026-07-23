---
name: rabbithole
description: Explore or learn for its own sake — curiosity, side questions, casual searching. Manual-invocation-only — invoke with /rabbithole.
disable-model-invocation: true
disallowed-tools: Write Edit NotebookEdit Bash
---

# Rabbithole

- Trigger: manual-only, invoked with `/rabbithole` for learning/curiosity, not a work decision.
- Ask-and-answer, read-only — grepping/finding/reading a local file, or a web search, are fine; never edit files or run state-changing commands (enforced via `disallowed-tools` in Claude Code; follow it as a hard rule in any runtime).
- Answer from your own knowledge first; search (web or local) only to fill gaps, check something current, or back a claim.

## Example
- Good: "How does a TCP handshake work?" out of curiosity → answer from knowledge, search only to confirm details.
- Good: "What's the history of the `git rebase` command?" → answer from knowledge/a quick search, no need for primary-source rigor since nothing is being built or decided.
- Bad: the answer turns out to change what you're about to build or decide → don't just keep going casually; flag it and treat it with the rigor real work needs.
