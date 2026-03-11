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
Commands / default handling flow
  |
  v
Orchestrator (hidden all-mode handler)
  |
  +---> Specialist (subagent) → execution
  +---> System (subagent) → diagnostics
  +---> Command (subagent) → command architecture

Specialized primary agents
  |
  +---> own command flows when intentionally designed that way
```

Rules:
- Hidden handlers can own default command routing without appearing in the public agent picker
- Specialized primary agents may own their own commands directly when that improves clarity
- Subagents do focused execution and bounded specialist work
- Enforce delegation boundaries via permission rules (e.g., `permission.task` in frontmatter)

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
