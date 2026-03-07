# Active Tasks & Work Items

Last Updated: 2026-03-08

---

## Completed

- ✅ Migrate to OpenCode native config
  - ✅ Create 4-agent deployment (Orchestrator, Manager, Specialist, System)
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
- ✅ Profile-based deployment system (lite/full profiles, deploy.sh, undeploy.sh)
- ✅ Pushed initial commit to GitHub (ClementBieber/opencode-copilot)
- ✅ Documentation updates for profile system (README.md, INSTRUCTIONS.md)
- ✅ Last30days extras created (research-synthesizer agent, last30days skill, /last30 command)
- ✅ Full profile deployed and verified (17/17 items)
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
- ✅ Cleaned duplicated skill catalogs from manager, specialist, system prompts
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
- ✅ profiles/full.txt updated with explore.md and general.md
- ✅ AGENTS.md architecture diagram updated with explore/general agents
- ✅ compaction.md and summary.md agents created (override built-in agents to use gpt-5-mini)
- ✅ Full duplication audit completed — 3 critical + 4 moderate duplications found and fixed:
  - Design principles (context-efficiency, unicity, delegation) consolidated into project-architecture skill
  - Blocked-state format deduplicated (SKILL.md → pointer to docs/delegation-spec.md)
  - Verify-your-work checklist deduplicated (specialist.md → development skill)
  - AGENTS.md line-count conflict resolved (standardized to 25 lines)
  - Compaction plugin recovery text slimmed (session-index docs = canonical)
- ✅ Full profile now at 24 deployed items (10 agents, 9 skills, 4 commands, 1 plugin)
- ✅ ECC skill extraction completed — 3 new skills created and deployed:
  - cost-aware-llm-pipeline (model routing, cost tracking, budget controls, prompt caching, retry policy)
  - autonomous-loops (loop patterns, exit conditions, state persistence, safety)
  - continuous-learning (session pattern extraction, confidence model, privacy, curation)
- ✅ Full profile now at 27 deployed items (10 agents, 12 skills, 4 commands, 1 plugin)
- ✅ Three ECC skill updates for OpenCode integration:
  - session-querying.md: removed redundant Option B, acknowledged native SQLite DB at ~/.local/share/opencode/opencode.db
  - continuous-learning implementation-guide: added OpenCode session DB as data source (schema, hook points, query pipeline)
  - cost-aware-llm-pipeline SKILL.md: added request-based billing model acknowledgment (GitHub Copilot)
- ✅ Fixed markdown formatting in all 6 ECC skill files (underline-style headers → ATX ## style)

## In Progress

- 🔄 Architecture change: all subagents on opus, orchestrator as thin router (feature/opus-subagents branch)
- 🔄 Push commits to GitHub (needs SSH agent or HTTPS+PAT — 9+ commits pending)

## Backlog

- Update README.md profile counts (currently stale — says 12/17, should reflect 27 items)
- System operations: install pip3/pipx/gh (needs sudo)
- Import legacy session archives into OpenCode DB (optional)
