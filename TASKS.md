# Active Tasks & Work Items

Last Updated: 2026-03-07

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

## In Progress

- 🔄 Push commits to GitHub (needs SSH)

## Backlog

- Import legacy session archives into OpenCode DB (optional)
- Formalize delegation protocol further (currently draft in skill docs)
- Design and implement session-index skill / compaction pointer model
- Selective ECC skill extraction (autonomous loops, continuous learning, cost-aware pipeline)
- System operations: add openskills to PATH permanently, install pip3/pipx/gh, clean PATH duplicates, consolidate OpenCode runtime locations
- Track and remove remaining duplicated information across prompts, skills, docs, and root files
