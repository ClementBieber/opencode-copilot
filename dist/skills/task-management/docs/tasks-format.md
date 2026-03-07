# TASKS.md Detailed Format Reference

## File Structure

```
# Active Tasks & Work Items

[Header paragraph explaining purpose and ownership rules]

---

## URGENT TASKS (Due within 1 day)
[Tasks or "_None currently_"]

---

## PHASE N TASKS (Due before Phase N+1 starts)

### Task: [Clear, Specific Task Name]
- **Status:** pending | in_progress | completed | blocked
- **Priority:** critical | high | medium | low
- **Owner:** [Agent name, "Project Team", or person]
- **Dependencies:** [Other task names or "None"]
- **Created:** [YYYY-MM-DD]
- **Due:** [YYYY-MM-DD or "Within N days/weeks"]
- **Completed:** [YYYY-MM-DD, only if completed]
- **Description:** [1-3 sentences describing what needs to be done]
  [Optional sub-items with checkboxes]

---

## COMPLETED TASKS
- [checkmark emoji] Task: [Task Name] (Milestone N.N)

---

## BLOCKED TASKS
[Tasks with blocker descriptions, or "_No tasks blocked currently_"]

---

## TASK STATISTICS
- **Total Tasks:** N
- **Urgent:** N
- **Critical:** N
- **High:** N
- **Medium:** N
- **Pending:** N
- **In Progress:** N
- **Completed:** N
- **Blocked:** N

**Last Updated:** YYYY-MM-DD
**Updated By:** [Context of last update]
```

## Field Rules

### Status Values
- `pending` - Not yet started
- `in_progress` - Currently being worked on
- `completed` - Done, add Completed date
- `blocked` - Cannot proceed, add blocker description

### Priority Values
- `critical` - Must be done before anything else
- `high` - Important for current phase
- `medium` - Normal work item
- `low` - Nice to have

### Owner Values
- Agent name (e.g., "Orchestrator", "Specialist")
- "Project Team" for collaborative tasks
- "[TBD]" or "[TBD - Phase N]" for unassigned future tasks

## Update Procedures

### Adding a New Task
1. Create under the appropriate phase section
2. Fill all required fields
3. Increment Total Tasks in statistics
4. Increment the appropriate priority counter
5. Increment Pending counter
6. Update Last Updated footer

### Completing a Task
1. Set Status to `completed`
2. Add `- **Completed:** YYYY-MM-DD`
3. Add entry to COMPLETED TASKS section
4. Decrement Pending/In Progress counter
5. Increment Completed counter
6. Update Last Updated footer

### Blocking a Task
1. Set Status to `blocked`
2. Add blocker description under the task
3. Copy task to BLOCKED TASKS section
4. Increment Blocked counter
5. Update Last Updated footer
