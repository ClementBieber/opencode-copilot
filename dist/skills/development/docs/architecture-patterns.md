# Architecture Patterns

## Config-as-Code Pattern

Define system behavior through declarative configuration files rather than imperative code:

- Agent behavior defined in markdown with YAML frontmatter
- Orchestration logic expressed as agent prompts, not code
- Configuration files are version-controlled and diffable
- Changes reflect immediately without rebuilds (when using symlink deployment)

## Agent Hierarchy Pattern

Structure agents in a clear delegation hierarchy:

```
User
  |
  v
Orchestrator (primary, expensive model)
  |
  +---> Manager (subagent, cheap model) → coordination
  |       |
  |       +---> Specialist (subagent, cheap model) → execution
  |       +---> System (subagent, cheap model) → diagnostics
  |
  +---> Specialist (direct delegation for simple tasks)
  |
  +---> System (direct delegation for infra/diagnostics)
```

Rules:
- Primary agent handles user interaction and high-level coordination
- Subagents do heavy execution on cheaper models
- Enforce hierarchy via permission rules (e.g., `permission.task` in frontmatter)
- Each level has a clear, non-overlapping responsibility

## Skills-as-Knowledge Pattern

Skills provide domain knowledge, not workflow automation:
- Agents load skills on-demand via the `skill` tool
- Skills contain reference information and guidelines
- Skills don't execute actions — they inform the agent's behavior
- Each skill has a concise SKILL.md + optional docs/ directory for deeper reference

## Symlink Deployment Pattern

Deploy configurations via symlinks for instant updates:

```
Project (source of truth)          System (deployment target)
dist/<category>/    ----symlink--->  ~/.config/<tool>/<category>/
```

Benefits:
- Edit in project, changes reflect immediately
- Version controlled (git tracks the project)
- Reversible (undeploy script removes only project symlinks)
- Preserves existing system configuration
