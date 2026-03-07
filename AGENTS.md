# OpenCode Copilot

Multi-agent orchestration system for OpenCode.

## Architecture

```
Orchestrator (claude-opus-4.6, primary)
├── Manager (gpt-5-mini, subagent)
├── Specialist (gpt-5-mini, subagent)
├── System (gpt-5-mini, subagent)
├── Explore (gpt-5-mini, built-in override)
├── General (gpt-5-mini, built-in override)
├── Compaction (gpt-5-mini, built-in override)
└── Summary (gpt-5-mini, built-in override)

Researcher (gpt-5-mini, primary)
├── @specialist (delegation)
└── @explore (delegation)
```

## Layout

- `dist/` — source of truth (agents, skills, commands, plugins)
- `scripts/deploy.sh` — symlinks dist/ → ~/.config/opencode/
- `TASKS.md` — active work items

## Design Principles

See `dist/skills/project-architecture/SKILL.md` for canonical architecture principles.

Key: only Orchestrator runs on the expensive model. All subagents and built-in overrides use gpt-5-mini.

Project-specific overview belongs here.
Agent details live in `dist/agents/*.md`.
Skill knowledge lives in `dist/skills/*/SKILL.md` and related `docs/` directories.

