# Duplication Audit

Status: active

Track duplicated information here until it is removed or moved to its canonical owner.

| Source | Duplicate / Drift | Canonical owner | Proposed action | Status |
|---|---|---|---|---|
| `AGENTS.md` | hard-coded agent count and architecture wording can drift from deployed profiles | `AGENTS.md` for overview only, agent files for details | simplify overview, avoid stale counts | in progress |
| `README.md` | duplicated skill and command inventories | skills/commands directories | reduce tables, point to canonical locations | in progress |
| `INSTRUCTIONS.md` | deployment and file-structure detail overlaps with deployment/system governance docs | future publication skill or opencode-integration docs | move publication/deployment ownership later | pending |
| `dist/agents/researcher.md` | archive/template/workflow details overlap with `research` skill | `dist/skills/research/*` | trim prompt to behavior and pointers | in progress |
| `dist/agents/research-synthesizer.md` | file-path/workflow/output details overlap with `last30days` skill | `dist/skills/last30days/*` | trim prompt to role and routing | in progress |
| `dist/commands/last30.md` | watchlist/history path details overlap with `last30days` skill | `dist/skills/last30days/SKILL.md` | keep command thin | in progress |
