#!/usr/bin/env bash
# deploy.sh - Create symlinks from ~/.config/opencode/ to dist/ subdirectories
# This preserves existing content in ~/.config/opencode/ (package.json, node_modules, etc.)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$PROJECT_DIR/dist"
CONFIG_DIR="$HOME/.config/opencode"

# Subdirectories to symlink
SUBDIRS=("agents" "skills" "commands" "plugins")

echo "Deploying OpenCode Copilot configs..."
echo "  Source: $DIST_DIR"
echo "  Target: $CONFIG_DIR"
echo ""

# Ensure config dir exists
mkdir -p "$CONFIG_DIR"

for subdir in "${SUBDIRS[@]}"; do
    source_path="$DIST_DIR/$subdir"
    target_path="$CONFIG_DIR/$subdir"

    if [ ! -d "$source_path" ]; then
        echo "  SKIP: $source_path does not exist"
        continue
    fi

    # If target already exists
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        if [ -L "$target_path" ]; then
            existing_target="$(readlink -f "$target_path")"
            if [ "$existing_target" = "$(readlink -f "$source_path")" ]; then
                echo "  OK:   $subdir/ already linked correctly"
                continue
            fi
            echo "  RELINK: $subdir/ (was -> $existing_target)"
            rm "$target_path"
        elif [ -d "$target_path" ]; then
            # Real directory exists - check if empty
            if [ -z "$(ls -A "$target_path" 2>/dev/null)" ]; then
                echo "  REPLACE: $subdir/ (empty directory -> symlink)"
                rmdir "$target_path"
            else
                echo "  ERROR: $target_path is a non-empty directory. Back it up first."
                echo "         Run: mv '$target_path' '$target_path.bak'"
                continue
            fi
        else
            echo "  ERROR: $target_path exists but is not a directory or symlink"
            continue
        fi
    fi

    ln -s "$source_path" "$target_path"
    echo "  LINK: $subdir/ -> $source_path"
done

echo ""
echo "Deploy complete."
echo ""
echo "Verify with: ls -la $CONFIG_DIR/"
