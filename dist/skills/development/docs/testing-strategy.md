# Testing Strategy

## Component Testing

### Agents
1. Deploy with `scripts/deploy.sh`
2. Open OpenCode in the project directory
3. Verify agents appear: Tab through primary agents (should see Orchestrator), @ mention subagents
4. Test basic delegation: Ask orchestrator to delegate a simple task to specialist
5. Verify hierarchy enforcement: Specialist should not be able to invoke Manager

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
2. Verify it delegates to Manager for coordination
3. Verify Manager delegates to Specialist for execution
4. Verify results flow back through the chain

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
- [ ] Orchestrator appears as primary agent in OpenCode
- [ ] Manager, Specialist, and System appear as subagents (@ menu)
- [ ] 4 skills appear in skill tool description
- [ ] `/order` command is available
- [ ] Orchestrator can delegate to Manager
- [ ] Orchestrator can delegate to Specialist
- [ ] Manager can delegate to Specialist
- [ ] Skills load correctly when invoked
- [ ] `scripts/undeploy.sh` cleanly removes symlinks
