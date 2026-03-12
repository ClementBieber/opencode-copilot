# Active Tasks & Work Items

Last Updated: 2026-03-12

---

## Completed

- ✅ Migrate to OpenCode native config
  - ✅ Create initial multi-agent deployment
  - ✅ Create project-architecture skill
  - ✅ Create /overview, /init, /order commands
- ✅ Implement Orchestrator loop using native `question` tool
- ✅ Context efficiency optimization
- ✅ Plugin enhancements — dynamic context injection (AGENTS.md, TASKS.md, git, project path)
- ✅ Anonymization review and git history cleanup for public release
- ✅ Rename project to OpenCode Copilot
- ✅ Clean export to ~/opencode-copilot/ (sole project folder)
- ✅ All dist/ files made fully project-agnostic
- ✅ Development skill rewritten as generic dev knowledge
- ✅ INSTRUCTIONS.md cleaned (no Python/yt-dlp, plugin version "latest")
- ✅ Old ~/oc-system-project/ deleted
- ✅ Deployment system created (deploy.sh, undeploy.sh)
- ✅ Pushed initial commit to GitHub (ClementBieber/opencode-copilot)
- ✅ Documentation updates for deployment system (README.md, INSTRUCTIONS.md)
- ✅ Last30days extras created (research-synthesizer agent, last30days skill, /last30 command)
- ✅ Full deployment set deployed and verified (17/17 items at the time)
- ✅ Researcher primary agent created with BCI domain knowledge, output templates, and enhanced archive system
- ✅ Orchestrator model changed to claude-opus-4.6
- ✅ Orchestrator loop hardened (strict ACT/QUESTION/STOP contract, steps: 12, Question Rules)
- ✅ Created delegation-protocol skill (shared blocked-state protocol, delegation-spec.md)
- ✅ Created publication skill (deployment guide, published-project-docs)
- ✅ Architecture knowledge centralized into 3 canonical docs:
  - project-architecture/docs/architecture-spec.md
  - delegation-protocol/docs/delegation-spec.md
  - opencode-integration/docs/system-integration-governance.md
- ✅ Created duplication-audit.md for tracking duplicated information
- ✅ Cleaned duplicated skill catalogs across agent prompts
- ✅ Generalized opencode-integration skill (removed project-specific counts/models)
- ✅ Trimmed researcher, research-synthesizer prompts (moved details to skills)
- ✅ Trimmed last30 command (moved path/persistence details to skill)
- ✅ Reduced README.md and AGENTS.md duplication; removed stale openskills XML block
- ✅ INSTRUCTIONS.md thinned to point at publication skill
- ✅ Sessions system analyzed (ephemeral layer, pointer+excerpt model recommended)
- ✅ everything-claude-code analyzed (extraction strategy documented, selective adoption recommended)
- ✅ Session-index skill created + compaction plugin rewritten (pointer+excerpt model, SHA-256 hashing)
- ✅ project-architecture skill fully generalized (removed all agent-system references)
- ✅ architecture-spec.md fully rewritten (project-type-agnostic)
- ✅ Created opencode-integration/docs/agent-system-architecture.md (generic agent design principles)
- ✅ /overview command reordered (general analysis first, OpenCode config last)
- ✅ PATH duplicates cleaned in ~/.bashrc
- ✅ explore.md and general.md agents created (override built-in agents to use gpt-5-mini)
- ✅ Deployment manifest updated with explore.md and general.md
- ✅ AGENTS.md architecture diagram updated with explore/general agents
- ✅ compaction.md and summary.md agents created (override built-in agents to use gpt-5-mini)
- ✅ Full duplication audit completed — 3 critical + 4 moderate duplications found and fixed:
  - Design principles (context-efficiency, unicity, delegation) consolidated into project-architecture skill
  - Blocked-state format deduplicated (SKILL.md → pointer to docs/delegation-spec.md)
  - Verify-your-work checklist deduplicated (specialist.md → development skill)
  - AGENTS.md line-count conflict resolved (standardized to 25 lines)
  - Compaction plugin recovery text slimmed (session-index docs = canonical)
- ✅ Deployment set expanded to 24 deployed items (10 agents, 9 skills, 4 commands, 1 plugin)
- ✅ ECC skill extraction completed — 3 new skills created and deployed:
  - cost-aware-llm-pipeline (model routing, cost tracking, budget controls, prompt caching, retry policy)
  - autonomous-loops (loop patterns, exit conditions, state persistence, safety)
  - continuous-learning (session pattern extraction, confidence model, privacy, curation)
- ✅ Deployment set expanded to 27 deployed items (10 agents, 12 skills, 4 commands, 1 plugin)
- ✅ Three ECC skill updates for OpenCode integration:
  - session-querying.md: removed redundant Option B, acknowledged native SQLite DB at ~/.local/share/opencode/opencode.db
  - continuous-learning implementation-guide: added OpenCode session DB as data source (schema, hook points, query pipeline)
  - cost-aware-llm-pipeline SKILL.md: added request-based billing model acknowledgment (GitHub Copilot)
- ✅ Fixed markdown formatting in all 6 ECC skill files (underline-style headers → ATX ## style)
- ✅ Architecture refactor: all subagents upgraded to claude-opus-4.6, orchestrator slimmed to thin router
  - Deleted built-in agent overrides (explore, general, compaction, summary) — they inherit caller's model
  - Deployment set reduced from 27 to 23 items (6 agents, 12 skills, 4 commands, 1 plugin)
  - Merged feature/opus-subagents → main
- ✅ README.md deployed-item count fixed (17 → 23)
- ✅ Investigated and mitigated "assistant message prefill" error:
  - Root cause: OpenCode appends assistant-role message at max steps; Claude 4.6 rejects prefill
  - Fix: increased orchestrator steps from 12 → 100
  - Upstream fix: PR #14772 (not yet merged in OpenCode v1.2.21)
- ✅ Added `/command` command and command-management subagent for interactive command creation/update flows
- ✅ Removed deprecated coordination subagent and repositioned Orchestrator as hidden default command handler
- ✅ Moved base `opencode.json` into `dist/` and updated symlink deployment/docs

## In Progress

- 🔄 Push commits to GitHub (needs SSH agent or HTTPS+PAT — 11+ commits pending)
- 🔄 Roll out canonical delegation protocol across delegating agents
  - Audit parent/subagent prompts against `dist/skills/delegation-protocol/docs/delegation-spec.md`
  - Standardize blocked-state and result-contract handling for delegating subagents
  - Document protocol scope boundary vs. user-facing presentation flavor
- 🔄 Define Phase 1 presentation-flavor model
  - Create canonical spec for presets backed by dimensions in `docs/presentation-flavor-spec.md`
  - Lock primary-agent-only scope and delegation boundary
  - Fix initial presets: `concise` (default), `teaching`, `technical`
- 🔄 Define Phase 2 default `concise` formatting contract for primary agents
  - Create canonical contract in `docs/concise-presentation-contract.md`
  - Keep high information density without reducing technical precision
  - Lock tested rules for headers, emphasis, ambiguity handling, and report behavior

## Backlog

- Build OpenCode from source with PR #14772 fix if prefill error persists (strips trailing assistant messages for Claude 4.6)
- System operations: install pip3/pipx/gh (needs sudo)
- Import legacy session archives into OpenCode DB (optional)
- Create a `@git` agent that specializes in Git-related operations
- Apply delegation protocol consistently to delegating agent prompts and verify parent integration behavior (see `docs/delegation-protocol-rollout-report.md`)
- Define Phase 3 preset behavior for `teaching` and `technical`
- Integrate shared presentation flavor into primary-agent prompts after protocol rollout
