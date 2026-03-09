#!/usr/bin/env python3

import argparse
import os
import shutil
import sqlite3
import sys
from datetime import datetime, timezone


def normalize_path(value: str) -> str:
    expanded = os.path.expanduser(value)
    absolute = os.path.abspath(expanded)
    return os.path.normpath(absolute)


def backup_database(db_path: str) -> str:
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    backup_path = f"{db_path}.bak-{timestamp}"
    shutil.copy2(db_path, backup_path)
    return backup_path


def fetch_project(cur: sqlite3.Cursor, worktree: str):
    row = cur.execute(
        "SELECT id, worktree, name, time_updated FROM project WHERE worktree = ?",
        (worktree,),
    ).fetchone()
    return row


def count_rows(cur: sqlite3.Cursor, table: str, project_id: str) -> int:
    query = f"SELECT COUNT(*) FROM {table} WHERE project_id = ?"
    return cur.execute(query, (project_id,)).fetchone()[0]


def count_prefixed_directories(cur: sqlite3.Cursor, table: str, old_path: str) -> int:
    return cur.execute(
        f"SELECT COUNT(*) FROM {table} WHERE directory = ? OR directory LIKE ?",
        (old_path, f"{old_path}/%"),
    ).fetchone()[0]


def replace_directory_prefix(
    cur: sqlite3.Cursor, table: str, old_path: str, new_path: str
) -> int:
    cur.execute(
        f"""
        UPDATE {table}
        SET directory = REPLACE(directory, ?, ?)
        WHERE directory = ? OR directory LIKE ?
        """,
        (old_path, new_path, old_path, f"{old_path}/%"),
    )
    return cur.rowcount


def confirm(prompt: str) -> bool:
    reply = input(f"{prompt} [y/N]: ").strip().lower()
    return reply in {"y", "yes"}


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Move OpenCode session history to a renamed or relocated project folder. "
            "Backs up the SQLite database before writing."
        )
    )
    parser.add_argument("--old-path", required=True, help="Previous project root path")
    parser.add_argument("--new-path", required=True, help="New project root path")
    parser.add_argument(
        "--db-path",
        default="~/.local/share/opencode/opencode.db",
        help="Path to OpenCode SQLite DB (default: %(default)s)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would change without modifying the database",
    )
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Skip interactive confirmation",
    )
    args = parser.parse_args()

    old_path = normalize_path(args.old_path)
    new_path = normalize_path(args.new_path)
    db_path = normalize_path(args.db_path)

    if old_path == new_path:
        print("Old and new paths are identical; nothing to do.", file=sys.stderr)
        return 2

    if not os.path.exists(db_path):
        print(f"OpenCode DB not found: {db_path}", file=sys.stderr)
        return 1

    if not os.path.exists(new_path):
        print(
            f"Warning: new path does not exist on disk yet: {new_path}", file=sys.stderr
        )

    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row

    try:
        cur = conn.cursor()
        old_project = fetch_project(cur, old_path)
        if old_project is None:
            print(f"No project row found for old path: {old_path}", file=sys.stderr)
            return 1

        new_project = fetch_project(cur, new_path)
        old_session_count = count_rows(cur, "session", old_project["id"])
        old_workspace_count = count_rows(cur, "workspace", old_project["id"])
        old_session_dirs = count_prefixed_directories(cur, "session", old_path)
        old_workspace_dirs = count_prefixed_directories(cur, "workspace", old_path)

        print("Migration plan")
        print(f"- DB: {db_path}")
        print(f"- Old path: {old_path}")
        print(f"- New path: {new_path}")
        print(f"- Old project id: {old_project['id']}")
        if new_project is None:
            print(
                "- New project row: not found; the existing project row will be retargeted"
            )
        else:
            print(
                f"- New project row: found ({new_project['id']}); sessions/workspaces will be moved onto it"
            )
        print(f"- Sessions on old project id: {old_session_count}")
        print(f"- Workspaces on old project id: {old_workspace_count}")
        print(f"- Session directories to rewrite: {old_session_dirs}")
        print(f"- Workspace directories to rewrite: {old_workspace_dirs}")

        if args.dry_run:
            print("Dry run only; no changes made.")
            return 0

        if not args.yes and not confirm("Proceed with database migration?"):
            print("Cancelled.")
            return 0

        backup_path = backup_database(db_path)
        print(f"Backup created: {backup_path}")

        conn.execute("BEGIN")

        if new_project is None or new_project["id"] == old_project["id"]:
            cur.execute(
                "UPDATE project SET worktree = ?, time_updated = ? WHERE id = ?",
                (
                    new_path,
                    int(datetime.now(timezone.utc).timestamp() * 1000),
                    old_project["id"],
                ),
            )
            target_project_id = old_project["id"]
        else:
            cur.execute(
                "UPDATE session SET project_id = ? WHERE project_id = ?",
                (new_project["id"], old_project["id"]),
            )
            moved_sessions = cur.rowcount
            cur.execute(
                "UPDATE workspace SET project_id = ? WHERE project_id = ?",
                (new_project["id"], old_project["id"]),
            )
            moved_workspaces = cur.rowcount
            target_project_id = new_project["id"]
            print(f"- Reassigned sessions to existing project row: {moved_sessions}")
            print(
                f"- Reassigned workspaces to existing project row: {moved_workspaces}"
            )

        updated_session_dirs = replace_directory_prefix(
            cur, "session", old_path, new_path
        )
        updated_workspace_dirs = replace_directory_prefix(
            cur, "workspace", old_path, new_path
        )
        conn.commit()

        print("Migration complete")
        print(f"- Active project id: {target_project_id}")
        print(f"- Session directories updated: {updated_session_dirs}")
        print(f"- Workspace directories updated: {updated_workspace_dirs}")
        print("- Next: open OpenCode in the new folder and verify the sessions appear")
        return 0
    except Exception as exc:
        conn.rollback()
        print(f"Migration failed: {exc}", file=sys.stderr)
        return 1
    finally:
        conn.close()


if __name__ == "__main__":
    sys.exit(main())
