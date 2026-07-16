# Personal Workflow Preferences

## Git
- Never stage, commit, or push — even if changes look ready or were previously approved; the user handles all git operations.
- Never run destructive git commands (force push, hard reset, `git clean`) or delete files/branches without explicit approval.

## Destructive Commands
- Never run destructive shell commands (e.g. `rm -rf`, overwriting files in place, killing unrelated processes) without explicit approval.
- Prefer non-destructive alternatives (move to trash/backup, dry-run flags) when available.

## Secrets
- Never commit, log, or echo secrets (.env, API keys, tokens).
- Warn before touching files that likely contain credentials.

## Scope of Changes
- Keep diffs minimal — only change what the task requires.
- Do not refactor, rename, or clean up unrelated code unless asked.
- Do not revert or overwrite changes you did not make — preserve the user's in-progress edits.

## Before Proposing Changes
- When unsure about implementation details, read the relevant source files first.
- Read callers and tests too, not just the file being edited.
- Do not guess at APIs, conventions, or behavior when the codebase or official documentation can answer the question.
- If still unsure after checking the codebase and official docs, ask the user rather than guessing.

## Documentation and Research
- Prefer official documentation for libraries and frameworks.
- Match the version in the project (CMakeLists.txt/Makefile, pom.xml/build.gradle, requirements.txt/pyproject.toml, package.json, go.mod, etc.) — do not assume latest.
- If official docs are missing or unclear, consult the project's official repository (README, source, examples).
- Do not rely on outdated blog posts or third-party summaries when official sources exist.

## Generated Files
- Never modify generated files (e.g. build output like `dist/`/`build/`/`target/`, lockfile artifacts like `package-lock.json`, codegen output like `*_generated.py`, `node_modules/`, `.venv/`).
- If a generated file needs to change, update the source or generator that produces it.

## Tests and Verification
- After non-trivial changes, run relevant tests or linters when the project has them.
- Report what you ran and the result — do not assume changes work without verification.
- Tests do not need exhaustive coverage — focus on important logic that must not break.

## Decisions with Trade-offs
- Ask before proceeding on choices with meaningful trade-offs — architecture, performance, compatibility, maintenance, new dependencies or major upgrades, and breaking changes to public APIs, database schemas, or config formats other code depends on.
- Present options briefly with pros/cons; do not pick unilaterally when the decision is the user's to make.
- Always explain the reason behind the choice you make, even when you decide without asking.
- Prefer libraries already used in the project over introducing new ones.
- Do not ask for approval on obvious, low-risk choices (naming a local variable, fixing a typo, following an existing pattern in the same file).

## Communication Style
- Keep progress updates and summaries concise — state what changed and why, skip narrating every step.
- Surface blockers, risks, or surprising findings proactively rather than burying them at the end.

## Environment and Tooling
- Do not install global packages/tools or modify system-level config (shell rc files, global git config, IDE/editor settings) without asking.
- Keep environment changes scoped to the project when possible.

## When Stuck
- After a couple of failed attempts at the same approach, stop and ask rather than keep trying variations.
- Explain what was tried and why it didn't work before proposing a different approach.
