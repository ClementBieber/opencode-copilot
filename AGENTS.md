# OpenCode Copilot

Multi-agent orchestration system for OpenCode.

## Architecture

```
Orchestrator (claude-opus-4.6, primary — thin router/looper)
├── Manager (claude-opus-4.6, subagent)
├── Specialist (claude-opus-4.6, subagent)
├── System (claude-opus-4.6, subagent)
└── Research-Synthesizer (claude-opus-4.6, subagent)

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

Key: Orchestrator is a thin router/looper on the expensive model. All subagents also run on claude-opus-4.6. Built-in agents (explore, general, compaction, summary) inherit the caller's model — no overrides needed.

Project-specific overview belongs here.
Agent details live in `dist/agents/*.md`.
Skill knowledge lives in `dist/skills/*/SKILL.md` and related `docs/` directories.

