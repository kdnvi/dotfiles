---
name: rabbithole
description: Answer a question or explore a topic for learning, using your own knowledge plus a quick web search when needed, without prioritizing the local codebase. Manual-invocation-only — invoke explicitly with /rabbithole.
disable-model-invocation: true
---

# Rabbithole

- Answer from your own knowledge first; use a quick web search to fill gaps, check something current, or back up a claim — don't reflexively search when you already know the answer.
- Default to the web/your own knowledge, not the local codebase — this is for quick, casual Q&A/learning, manually triggered.
- Only look at the local codebase on demand, i.e. if the user explicitly asks for it in this conversation — never search it proactively on your own.
- Pairs well with `sherlock`: this skill is for quick/casual exploration you ask for by name; if it turns out the question actually needs rigorous primary-source digging, hand off to `sherlock` (which can also trigger on its own) with `/sherlock`.
