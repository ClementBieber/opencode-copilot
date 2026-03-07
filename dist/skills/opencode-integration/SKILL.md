---
name: opencode-integration
description: Knowledge about OpenCode's native configuration system including agents, skills, commands, plugins, rules, permissions, compaction, and deployment. Load this skill when working on OpenCode config files or understanding how the agent system deploys to ~/.config/opencode/.
---

# OpenCode Integration Knowledge

## System Architecture

OpenCode configurations are typically stored as agents, skills, commands, and plugins, then deployed into `~/.config/opencode/` or project-local `.opencode/` directories.

```
dist/
  agents/     -> ~/.config/opencode/agents/
  skills/     -> ~/.config/opencode/skills/
  commands/   -> ~/.config/opencode/commands/
  plugins/    -> ~/.config/opencode/plugins/
```

## Agent Configuration Format

Agents are markdown files with YAML frontmatter. File name = agent name.

**Location:** `~/.config/opencode/agents/<name>.md` or `.opencode/agents/<name>.md`

**Frontmatter fields:**
- `description` (required) - what the agent does
- `mode` - `primary` | `subagent` | `all` (default: `all`)
- `model` - `provider/model-id` format
- `temperature` - 0.0-1.0
- `top_p` - 0.0-1.0
- `steps` - max agentic iterations
- `tools` - enable/disable tools (`write`, `edit`, `bash`, `skill`, etc.)
- `permission` - per-tool permission overrides
- `hidden` - hide subagent from @ menu (subagents only)
- `color` - hex or theme color
- `disable` - set true to disable

**Permission structure:**
```yaml
permission:
  edit: allow | ask | deny
  bash:
    "*": ask
    "git status": allow
  task:
    "*": deny
    "specialist": allow
  skill: allow
  webfetch: deny
```

Task permissions: last matching glob rule wins. `deny` removes agent from Task tool description entirely.

**Body after frontmatter** = system prompt.

## Skill Configuration Format

Skills are `SKILL.md` files in named directories.

**Location:** `~/.config/opencode/skills/<name>/SKILL.md`

**Frontmatter fields (only these are recognized):**
- `name` (required) - must match directory name, lowercase alphanumeric + hyphens, 1-64 chars
- `description` (required) - 1-1024 chars
- `license` (optional)
- `compatibility` (optional)
- `metadata` (optional) - string-to-string map only

Body = instructions loaded when agent calls `skill({ name: "skill-name" })`.

**Name validation regex:** `^[a-z0-9]+(-[a-z0-9]+)*$`

## Commands Format

Commands are markdown files. File name = command name (invoked as `/name`).

**Location:** `~/.config/opencode/commands/` or `.opencode/commands/`

Body = instructions executed when user runs the command.

## Plugins Format

Plugins are TypeScript files using the `@opencode-ai/plugin` SDK.

**Location:** `~/.config/opencode/plugins/`

Available hooks:
- `experimental.session.compacting` - inject context during compaction

## Config Precedence

Remote -> Global (`~/.config/opencode/opencode.json`) -> Custom -> Project (`opencode.json`) -> `.opencode` directories.

Later sources override earlier ones. Configs are **merged**, not replaced.

## Common Deployment Pattern

Many OpenCode setups use:
- a primary orchestration agent
- one or more subagents for focused execution
- skills for on-demand knowledge
- commands for user-facing shortcuts
- plugins for runtime hooks

## Deployment

- Deployment is often handled by project scripts that create symlinks from a source-of-truth directory such as `dist/` into `~/.config/opencode/`
- Safe deployment should preserve unrelated existing content in `~/.config/opencode/`

## Reference

For detailed documentation, see `docs/` in this skill directory:
- `docs/config-reference.md` - Full opencode.json schema reference
- `docs/model-providers.md` - Available providers and model IDs
- `docs/agent-system-architecture.md` - Design principles for agents, skills, commands, and plugins
- `docs/system-integration-governance.md` - Rules for integrating tools into the Linux/OpenCode environment
