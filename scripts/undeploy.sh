#!/usr/bin/env bash
# undeploy.sh - Remove symlinks from ~/.config/opencode/ that point to dist/
# Only removes symlinks, never deletes real directories or files.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$PROJECT_DIR/dist"
CONFIG_DIR="$HOME/.config/opencode"

# Subdirectories to unlink
SUBDIRS=("agents" "skills" "commands" "plugins")

echo "Undeploying OpenCode Copilot configs..."
echo "  Config dir: $CONFIG_DIR"
echo ""

for subdir in "${SUBDIRS[@]}"; do
    target_path="$CONFIG_DIR/$subdir"

    if [ ! -L "$target_path" ]; then
        if [ -e "$target_path" ]; then
            echo "  SKIP: $subdir/ is not a symlink (real directory/file)"
        else
            echo "  SKIP: $subdir/ does not exist"
        fi
        continue
    fi

    # Verify the symlink points to our dist/ dir before removing
    link_target="$(readlink -f "$target_path")"
    expected_target="$(readlink -f "$DIST_DIR/$subdir")"

    if [ "$link_target" = "$expected_target" ]; then
        rm "$target_path"
        echo "  REMOVED: $subdir/ (was -> $link_target)"
    else
        echo "  SKIP: $subdir/ points elsewhere ($link_target)"
    fi
done

echo ""
echo "Undeploy complete."
echo "Verify with: ls -la $CONFIG_DIR/"
