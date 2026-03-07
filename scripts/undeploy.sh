#!/usr/bin/env bash
# undeploy.sh - Remove symlinks deployed by deploy.sh
# Reads the deployment record or falls back to scanning categories

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$PROJECT_DIR/dist"
CONFIG_DIR="$HOME/.config/opencode"

RECORD_FILE="$CONFIG_DIR/.opencode-copilot-deployed"

echo "Undeploying OpenCode Copilot configs..."
echo "  Config dir: $CONFIG_DIR"
echo "  Source: $DIST_DIR"
echo ""

items_to_remove=()

if [ -f "$RECORD_FILE" ]; then
    # Read declared items (skip comments)
    while IFS= read -r line || [ -n "$line" ]; do
        entry="$line"
        entry="$(echo "$entry" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        case "$entry" in
            ''|\#*)
                continue
                ;;
        esac
        items_to_remove+=("$entry")
    done < "$RECORD_FILE"
else
    echo "No deployment record found at $RECORD_FILE. Scanning for symlinks pointing to $DIST_DIR"
    CATS=("agents" "skills" "commands" "plugins")
    for cat in "${CATS[@]}"; do
        dir="$CONFIG_DIR/$cat"
        if [ ! -d "$dir" ]; then
            continue
        fi
        # Iterate entries
        for entry in "$dir"/*; do
            [ -e "$entry" ] || continue
            if [ -L "$entry" ]; then
                target="$(readlink -f "$entry")"
                case "$target" in
                    "$DIST_DIR"/*)
                        # compute relative path from dist/
                        rel="${target#$DIST_DIR/}"
                        items_to_remove+=("$rel")
                        ;;
                esac
            fi
        done
    done
fi

removed=0
skipped=0
for item in "${items_to_remove[@]}"; do
    tgt="$CONFIG_DIR/$item"
    if [ ! -L "$tgt" ]; then
        echo "  SKIP: $item -> not a symlink"
        skipped=$((skipped+1))
        continue
    fi
    link_target="$(readlink -f "$tgt")"
    case "$link_target" in
        "$DIST_DIR"/*)
            rm "$tgt"
            echo "  REMOVED: $item (was -> $link_target)"
            removed=$((removed+1))
            ;;
        *)
            echo "  SKIP: $item -> points elsewhere ($link_target)"
            skipped=$((skipped+1))
            ;;
    esac
done

# Remove record file if it exists
if [ -f "$RECORD_FILE" ]; then
    rm "$RECORD_FILE"
    echo "Removed deployment record: $RECORD_FILE"
fi

echo ""
echo "Summary: removed=$removed skipped=$skipped"
echo "Undeploy complete."
