# OpenCode Copilot

Multi-agent orchestration system for OpenCode.

## Architecture

```
Orchestrator (gpt-5.4, primary — thin router/looper)
├── Manager (claude-opus-4.6, subagent)
├── Command (claude-opus-4.6, subagent)
├── Taskmaster (claude-opus-4.6, subagent)
├── Specialist (claude-opus-4.6, subagent)
├── System (claude-opus-4.6, subagent)
├── Research-Synthesizer (claude-opus-4.6, subagent)
├── Explore (claude-opus-4.6, built-in override)
├── General (claude-opus-4.6, built-in override)
├── Compaction (claude-opus-4.6, built-in override)
└── Summary (claude-opus-4.6, built-in override)

Researcher (gpt-5.4, primary)
├── @specialist (delegation)
├── @system (delegation)
└── @explore (delegation)
```

## Layout

- `dist/` — source of truth (agents, skills, commands, plugins)
- `scripts/deploy.sh` — symlinks dist/ → ~/.config/opencode/
- `TASKS.md` — active work items

## Design Principles

See `dist/skills/project-architecture/SKILL.md` for canonical architecture principles.

Key: Primary agents (Orchestrator, Researcher) run on gpt-5.4 by default. All subagents and built-in overrides run on claude-opus-4.6 for higher-quality execution.

Project-specific overview belongs here.
Agent details live in `dist/agents/*.md`.
Skill knowledge lives in `dist/skills/*/SKILL.md` and related `docs/` directories.
