# Project Moves and Session Continuity

When a project is renamed, moved to a different folder, extracted into its own repo, or merged into another repo, update OpenCode's conversations database too.

Without this step, the conversation data still exists, but the TUI session list may no longer show it from the new folder because sessions are linked through project-scoped DB rows.

## Preferred Helper For Whole-Project Moves

For the common case where the whole project was renamed or moved, use the helper instead of editing SQL manually:

```bash
python3 ~/.config/opencode/skills/opencode-integration/scripts/move_project_sessions.py \
  --old-path /old/path/project \
  --new-path /new/path/project
```

What it does:

- inspects the current `project`, `session`, and `workspace` rows
- creates a timestamped backup of `~/.local/share/opencode/opencode.db`
- updates path-linked rows inside a single transaction
- if OpenCode already created a destination `project` row for the new folder, reassigns sessions/workspaces onto it automatically

Useful flags:

- `--dry-run` - preview the migration plan without changing the DB
- `--yes` - skip the confirmation prompt
- `--db-path <path>` - target a different OpenCode DB file

## Database Location

- SQLite DB: `~/.local/share/opencode/opencode.db`

Relevant tables:

- `project` - canonical project/worktree identity
- `session` - per-conversation records, including `project_id` and `directory`
- `workspace` - workspace rows linked to `project_id`, with an optional `directory`

## Rules

Always do this after:

- renaming a project folder
- moving a project to another parent directory
- extracting part of a project into a new standalone project
- merging a project into another existing project

## Safety Checklist

1. Close OpenCode before editing the DB.
2. Back up `~/.local/share/opencode/opencode.db` first.
3. Make all edits inside a single transaction.
4. Re-open OpenCode in the destination folder and verify the old sessions are visible.

## Whole-Project Rename or Move

If you are not using the helper, and the whole project moved but it is still logically the same project, keep the same `project.id` and update the stored paths.

Typical fields to update:

- `project.worktree`
- `session.directory`
- `workspace.directory` (when present)

Example shape:

```sql
BEGIN;

UPDATE project
SET worktree = '/new/path/project'
WHERE worktree = '/old/path/project';

UPDATE session
SET directory = REPLACE(directory, '/old/path/project', '/new/path/project')
WHERE directory LIKE '/old/path/project%';

UPDATE workspace
SET directory = REPLACE(directory, '/old/path/project', '/new/path/project')
WHERE directory LIKE '/old/path/project%';

COMMIT;
```

If OpenCode already created a second `project` row for the new folder, merge back to one canonical project row by moving sessions/workspaces onto the project you want to keep, then delete the duplicate row.

## Project Split or Extraction

If part of a project becomes a new standalone repo:

1. Open the new folder once so OpenCode creates its destination `project` row.
2. Identify the sessions that should move with the extracted project.
3. Reassign those `session.project_id` rows to the new project's id.
4. Update their `session.directory` values to the new root.
5. Reassign any related `workspace.project_id` / `workspace.directory` rows.

Example shape:

```sql
BEGIN;

UPDATE session
SET project_id = '<new_project_id>',
    directory = REPLACE(directory, '/old/path/subproject', '/new/path/subproject')
WHERE id IN ('ses_1', 'ses_2');

UPDATE workspace
SET project_id = '<new_project_id>',
    directory = REPLACE(directory, '/old/path/subproject', '/new/path/subproject')
WHERE project_id = '<old_project_id>'
  AND directory LIKE '/old/path/subproject%';

COMMIT;
```

Use explicit session ids when splitting a project so you only move the conversations that belong with the extracted work.

## Merge Into Another Existing Project

If one project is absorbed into another:

1. Decide which destination `project.id` should own the history.
2. Reassign the relevant `session.project_id` rows to that destination id.
3. Update session/workspace directories to the new location.
4. Remove the obsolete `project` row only after verifying nothing still references it.

## Verification

After the DB edit:

- open OpenCode in the new folder
- confirm the expected sessions appear in the session list
- spot-check a migrated session title and contents
- confirm no duplicate empty project entry was left behind

This is a required post-move hygiene step whenever project paths change and you want prior conversations to remain accessible from the new location.
