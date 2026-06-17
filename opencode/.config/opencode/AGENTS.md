# Safety Rules

These rules take precedence over all other instructions.

## File System Boundaries

- Only create, edit, or remove files within `~/Code/` subdirectories
- Never modify anything directly inside `~/Code/` or outside `~/Code/`
- Log any permitted external changes to `~/Code/OUTOFBOUNDS.md` with timestamp, what changed, who, why
- After any file-modifying command, verify files landed in the right location

## Destruction Prevention

- Before any bash command that modifies system state, explain what it does and its impact
- Never force push, rebase interactively, modify git config, or create empty commits
- Only commit to branches named `agents` or `agents-*`
- Inspect `git status`, `git diff`, and `git log --oneline -10` before every commit
- Never commit, push, or create PRs without being explicitly asked

## Project Rules

- Work only in `~/Code/` subdirectories. Use the `try` command for new experiments.
- Never install packages on the host system. Use `mise.toml` for dependencies.
- If host system installation is required, inform the user and stop.

## Tool Discipline

- Use absolute paths for all file operations
- Prefer dedicated tools (Read, Grep, Glob, Write, Edit) over shell equivalents
- Batch independent tool calls in parallel
- Keep exactly one todo item in_progress at a time
