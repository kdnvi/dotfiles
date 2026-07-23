# Personal Workflow Preferences

## Git
- Never stage, commit, or push, even if changes look ready or were previously approved — the user handles all git operations.
- Never force-push, hard-reset, `git clean`, or delete files/branches without explicit approval.

## Destructive Commands
- Never run destructive shell commands (`rm -rf`, in-place overwrites, killing unrelated processes) without explicit approval.
- Prefer non-destructive alternatives (trash/backup, dry-run) when available.

## Secrets
- Never commit, log, or echo secrets (.env, API keys, tokens).
- Warn before touching files that likely contain credentials.

## Scope of Changes
- Keep diffs minimal — only change what the task requires.
- Don't refactor, rename, or clean up unrelated code unless asked.
- Don't revert or overwrite the user's in-progress edits.

## Generated Files
- Never modify generated files (build output, lockfiles, codegen, `node_modules/`, `.venv/`).
- If a generated file needs to change, update its source/generator instead.

## Communication Style
- Keep updates concise — what changed and why, not a play-by-play.
- Surface blockers and risks proactively, not at the end.
- Push back when something looks wrong; propose alternatives instead of rubber-stamping.

## Environment and Tooling
- Don't install global packages or touch system-level config (shell rc, global git, IDE settings) without asking.
- Keep environment changes scoped to the project.

## When Stuck
- After a couple of failed attempts, stop and ask instead of trying more variations.
- Explain what was tried and why it failed before proposing a new approach.

## Skill Usage
- Announce which skill you're using before applying it.

## Task Workflow

Plan Mode selects the track:
- Active → non-trivial pipeline (below).
- Inactive → trivial mode (dynamic, no fixed pipeline).

If complexity only becomes clear mid-conversation, say so and suggest switching to Plan Mode instead of running the full pipeline inside a trivial chat.

### Non-trivial (Plan Mode active)
Discuss throughout, not just once:
1. Research — ground facts/APIs/codebase behavior (`sherlock`).
2. Clarify — ask/challenge/answer until requirements are solid.
3. Design — full picture (approach, alternatives, risks); iterate until feasible; write the design doc (`whiteboard`).
4. Build — exit Plan Mode. If TDD applies, run `guinea-pig` first (it owns the criteria); otherwise implement directly. If stuck, stop and discuss (see "When Stuck").
5. Verify — sanity-check + unit tests (`guinea-pig`); loop into `exterminator` for failures, consulting the user each fix-and-retest iteration (see `exterminator`).
6. Review — run `nitpick`; only a clean pass is approved. Same per-loop consult rule applies (see `nitpick`).
7. Close out — ask if docs need updating; run `ghostwriter` only if yes.

### Trivial (default)
No fixed sequence — reach for whichever skill fits (`sherlock`, `guinea-pig`, `exterminator`, `nitpick`, etc.). Ask if unclear. Skip the pipeline, not the loop-consult safety rule (steps 5-6).

### Aside: `rabbithole`
Manual-only (`/rabbithole`), separate from the pipeline. Ask-and-answer, read-only — no edits or state-changing commands. Short answers; elaborate only if asked.
