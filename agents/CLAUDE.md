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

## Generated Files
- Never modify generated files (e.g. build output like `dist/`/`build/`/`target/`, lockfile artifacts like `package-lock.json`, codegen output like `*_generated.py`, `node_modules/`, `.venv/`).
- If a generated file needs to change, update the source or generator that produces it.

## Communication Style
- Keep progress updates and summaries concise — state what changed and why, skip narrating every step.
- Surface blockers, risks, or surprising findings proactively rather than burying them at the end.
- Push back and debate when something looks wrong or there's a better approach, rather than just complying; brainstorm alternatives when it would help, instead of rubber-stamping the first idea (yours or the user's).

## Environment and Tooling
- Do not install global packages/tools or modify system-level config (shell rc files, global git config, IDE/editor settings) without asking.
- Keep environment changes scoped to the project when possible.

## When Stuck
- After a couple of failed attempts at the same approach, stop and ask rather than keep trying variations.
- Explain what was tried and why it didn't work before proposing a different approach.

## Skills

If it's unclear which skill (if any) applies to the current situation, ask rather than guessing.

| Situation | Skill |
|---|---|
| Actual work — a decision, trade-off, API, or codebase behavior — needs grounding in primary sources before acting or deciding | `sherlock` |
| Investigating a bug, error, or unexpected behavior | `exterminator` |
| Writing tests for new logic or a bug fix | `guinea-pig` |
| Presenting a non-trivial multi-step plan, or a choice involves architecture, a new dependency, a major upgrade, or a breaking change | `whiteboard` |
| Asked to write/update human-facing docs (README, guide, changelog) — only as the last step, after the work is done and explicitly approved | `ghostwriter` |
| Finished a non-trivial change, or about to tell the user a task is complete | `nitpick` |
| Quick web search for Q&A/learning, unrelated to the current codebase | `rabbithole` (manual-only — invoke explicitly with `/rabbithole`) |
