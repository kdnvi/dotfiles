---
name: sherlock
description: Scout for information from primary sources when a question can't be confidently answered from existing knowledge, and brainstorm on what's found. Not limited to code — use for any research need before acting, deciding, or discussing something, whenever it actually requires looking something up rather than being answerable outright.
---

# Sherlock

## When to actually use this
Skip this for questions you can already answer confidently — this is for things that genuinely need looking up (unfamiliar APIs/libraries, unclear codebase behavior, a claim worth double-checking, prior art for a decision), not routine questions.

## Scout
- Investigate the question against primary sources — official docs, source code, specs, first-party APIs — not a secondary write-up of them.
- Follow every claim back to the source that owns it.
- Pull from whatever sources the question actually needs — codebase, official docs, similar projects, specs/RFCs — not just the first one that comes to mind.
- When it's about this codebase specifically: read the relevant source files, callers, and tests before editing, and match the version actually used in the project (CMakeLists.txt/Makefile, pom.xml/build.gradle, requirements.txt/pyproject.toml, package.json, go.mod, etc.) rather than assuming latest.

## Brainstorm on findings
- Don't just dump facts — synthesize them: what they mean, what's still unclear, what follow-up questions they raise.
- Surface disagreements or gaps between sources instead of picking one silently.

## When still unsure
Ask the user rather than guessing.

## Related
Can be useful during `whiteboard`'s discussion/alternatives step, or on its own for any research need — invoke directly with `/sherlock` if it doesn't trigger automatically.
