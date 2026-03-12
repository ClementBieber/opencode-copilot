# Testing Strategy

## Component Testing

### Agents
1. Deploy with `scripts/deploy.sh`
2. Open OpenCode in the project directory
3. Verify visible primary agents match the intended public set and that hidden agents do not appear in the mode picker
4. Verify `orchestrator` is still reachable through command routing and internal delegation flows
5. Test basic delegation: Ask orchestrator to delegate a simple task to specialist

### Skills
1. After deploy, verify skills appear in skill tool description
2. Load each skill: `skill({ name: "opencode-integration" })`, etc.
3. Verify content is loaded correctly (check instructions appear in context)

### Commands
1. Verify `/order` command appears in command list
2. Run `/order` and verify it executes the command instructions

### Plugins
1. Verify plugin loads without errors on OpenCode startup
2. Trigger compaction (fill context or use `/compact`)
3. Verify compaction hook fires and injects custom context

## Integration Testing

### Full Delegation Chain
1. Ask Orchestrator a complex multi-step task
2. Verify it delegates directly to the most appropriate subagent when delegation is needed
3. Verify results flow back cleanly to the user

### Skill Loading in Delegation
1. Ask Orchestrator to update TASKS.md
2. Verify it loads the `task-management` skill (or instructs subagent to)
3. Verify the update follows the correct format

### Post-Compaction Recovery
1. Work until compaction triggers
2. Verify Orchestrator reads project files after compaction
3. Verify work continues correctly

## Smoke Test Checklist

- [ ] `scripts/deploy.sh` runs without errors
- [ ] `scripts/deploy.sh --verbose` shows per-item deployment details when needed
- [ ] If GitHub push over SSH fails but `gh auth status` is healthy, verify `gh`-backed HTTPS push works without changing the remote
- [ ] Orchestrator is hidden from the agent picker
- [ ] Researcher appears as an intentional visible primary agent
- [ ] Specialist and System appear as subagents (@ menu)
- [ ] Deployed skills appear in the skill tool description
- [ ] `/order` command is available
- [ ] Orchestrator can delegate to Specialist
- [ ] Orchestrator-owned commands route correctly
- [ ] Skills load correctly when invoked
- [ ] `scripts/undeploy.sh` cleanly removes symlinks
