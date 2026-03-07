---
name: project-architecture
description: "Agentic project architecture pattern: minimal project files, agent hierarchy, on-demand skills, dist/ deployment via symlinks."
license: MIT
compatibility: ">=1.0.0"
---

# Project Architecture Skill

Reusable pattern for multi-agent projects that optimize for context efficiency, unicity, and strict ownership boundaries.

## Core Principle: Unicity

Every piece of information exists in exactly one place:
- **Agent prompts** define behavior (dist/agents/*.md)
- **Skills** hold domain knowledge (dist/skills/*/SKILL.md) — loaded on-demand
- **AGENTS.md** holds general project structure and project-specific overview
- **TASKS.md** tracks work state
- **README.md** is the public entry point

Never duplicate information across files. Reference it instead.

## Minimal Project Files

Only keep files that serve a distinct, non-redundant purpose:

| File | Purpose |
|------|---------|
| `AGENTS.md` | General architecture overview, structure, and project-specific context |
| `TASKS.md` | Active work items |
| `README.md` | Public-facing project description and quick start |
| `INSTRUCTIONS.md` | Published-project operator/contributor instructions only |

All other knowledge lives in skills (loaded on-demand) or agent prompts (always loaded with that agent).

`INSTRUCTIONS.md` should only exist when the project is intended for publication or external consumption.

## Agent Hierarchy Pattern

```
Primary (expensive model) — orchestration, delegation, user interaction
├── Manager (cheap model) — task decomposition, coordination
├── Specialist (cheap model) — focused execution
└── System (cheap model) — diagnostics, infrastructure
```

Design for context efficiency:
- Primary agent delegates aggressively to minimize its own context usage
- Subagents use cheaper models for all heavy lifting
- Skills provide knowledge on-demand — not preloaded into every conversation

Keep it minimal. Add files and skills only when they serve a clear, non-redundant purpose.

## Detailed Standards

For the full general project architecture standard, see:

- `docs/architecture-spec.md`
