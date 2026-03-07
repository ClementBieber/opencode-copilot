---
name: development
description: Software development knowledge including coding patterns, architecture decisions, testing strategy, and code quality practices. Load this skill when writing code, reviewing architecture, or making implementation decisions.
---

# Development Knowledge

## Architecture Principles

1. **Native-first** — Use platform built-in features instead of custom code
2. **Config as code** — Define behavior declaratively when possible
3. **Separation of concerns** — Clear boundaries between orchestration, knowledge, and runtime
4. **Context efficiency** — Minimize token usage. Expensive models orchestrate, cheap models execute.
5. **Unicity** — Information exists in one place only. Reference, don't duplicate.

## Coding Standards

### Markdown Files
- Frontmatter must be valid YAML
- Keep content concise — focused instructions work better than verbose ones
- Use headers to organize sections logically

### TypeScript
- Use typed exports (e.g., `export const MyPlugin: Plugin = async (ctx) => { ... }`)
- Handle errors gracefully with try/catch
- One concern per module
- Prefer async/await over raw promises

### Bash Scripts
- Use `set -euo pipefail`
- Quote all variable expansions and paths
- Check preconditions before destructive operations
- Provide clear output messages

## Testing Strategy

- **Unit testing:** Test individual components in isolation
- **Integration testing:** Verify components work together end-to-end
- **Smoke testing:** Quick deployment verification checklist
- **Manual verification:** Re-read files, check command output after changes

See `docs/testing-strategy.md` for detailed testing procedures.

## Git Practices

- Strategic commits only — meaningful, completed work
- Commit message format: concise description of the "why", not the "what"
- Never commit secrets, credentials, or environment files
- Use `.gitignore` to exclude generated files, secrets, and editor configs

## Code Quality

- Verify your work before reporting (re-read files, check output)
- Prefer editing existing files over creating new ones
- Keep files focused — one concern per file
- Document non-obvious decisions with brief comments

## Reference

For detailed documentation, see `docs/` in this skill directory:
- `docs/architecture-patterns.md` — Common architecture patterns
- `docs/testing-strategy.md` — Testing procedures and checklists
