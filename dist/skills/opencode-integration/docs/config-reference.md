# OpenCode Configuration Reference

## opencode.json Schema

The project-level `opencode.json` configures OpenCode behavior.

### Top-Level Fields

```json
{
  "$schema": "https://opencode.ai/config.json",
  "compaction": {
    "auto": true
  },
  "agent": {
    "<agent-name>": { ... }
  },
  "tools": {
    "<tool-name>": true | false
  },
  "permission": {
    "edit": "allow" | "ask" | "deny",
    "bash": { "<glob>": "allow" | "ask" | "deny" },
    "skill": { "<glob>": "allow" | "ask" | "deny" },
    "webfetch": "allow" | "ask" | "deny"
  }
}
```

### Agent Configuration in JSON

```json
{
  "agent": {
    "my-agent": {
      "description": "Required description",
      "mode": "primary | subagent | all",
      "model": "provider/model-id",
      "temperature": 0.0-1.0,
      "top_p": 0.0-1.0,
      "steps": 10,
      "disable": false,
      "hidden": false,
      "color": "#hex or theme-color",
      "prompt": "{file:./path/to/prompt.txt}",
      "tools": { "write": true, "bash": false },
      "permission": { ... }
    }
  }
}
```

### Config Precedence (in order, later wins)

1. Remote config
2. Global (`~/.config/opencode/opencode.json`)
3. Custom config
4. Project (`opencode.json` in project root)
5. `.opencode/` directory configs

Configs are **merged**, not replaced.

### Config File Locations

| Type | Location |
|------|----------|
| Global config | `~/.config/opencode/opencode.json` |
| Project config | `./opencode.json` |
| Global agents | `~/.config/opencode/agents/*.md` |
| Project agents | `.opencode/agents/*.md` |
| Global skills | `~/.config/opencode/skills/*/SKILL.md` |
| Project skills | `.opencode/skills/*/SKILL.md` |
| Global commands | `~/.config/opencode/commands/*.md` |
| Project commands | `.opencode/commands/*.md` |
| Global plugins | `~/.config/opencode/plugins/*.ts` |
| Global rules | `~/.config/opencode/rules/*.md` |
| Project rules | `.opencode/rules/*.md` |
