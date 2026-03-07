---
name: task-management
description: Knowledge about reading and updating TASKS.md. Covers task format, status tracking, and conventions.
---

# Task Management Knowledge

## TASKS.md Format

TASKS.md is the project's only persistent work tracker. Keep it simple and scannable.

### Structure

```markdown
# Active Tasks & Work Items

Last Updated: YYYY-MM-DD

---

## Completed
- ✅ Task description — completed [date]

## In Progress
- 🔄 Task description — context

## Backlog
- Task idea or future work
```

### Status Icons

| Icon | Meaning |
|------|---------|
| ✅ | Completed |
| 🔄 | In progress |
| ❌ | Blocked |
| (none) | Backlog / idea |

### Rules

1. Keep entries concise — one line per task
2. Move completed tasks to the Completed section
3. Update "Last Updated" date after changes
4. No duplication — if information lives elsewhere (in a skill, agent prompt, or code), reference it instead of repeating it
