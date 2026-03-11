#!/usr/bin/env bash
# deploy.sh - Create symlinks from ~/.config/opencode/ to dist/ files and dirs
# Supports profile-based deployments (profiles/*.txt)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$PROJECT_DIR/dist"
CONFIG_DIR="$HOME/.config/opencode"

PROFILE_NAME="lite"

# Parse args
while [ "$#" -gt 0 ]; do
    case "$1" in
        --profile)
            shift
            if [ "$#" -eq 0 ]; then
                echo "Usage: $0 [--profile <name>]" >&2
                exit 2
            fi
            PROFILE_NAME="$1"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--profile <name>]" >&2
            exit 0
            ;;
        *)
            echo "Unknown arg: $1" >&2
            echo "Usage: $0 [--profile <name>]" >&2
            exit 2
            ;;
    esac
done

PROFILE_FILE="$PROJECT_DIR/profiles/${PROFILE_NAME}.txt"

echo "Deploying OpenCode Copilot configs (profile: $PROFILE_NAME)..."
echo "  Source: $DIST_DIR"
echo "  Target: $CONFIG_DIR"
echo "  Profile: $PROFILE_FILE"
echo ""

if [ ! -f "$PROFILE_FILE" ]; then
    echo "ERROR: profile file not found: $PROFILE_FILE" >&2
    exit 1
fi

mkdir -p "$CONFIG_DIR"

# Categories
SUBDIRS=("agents" "skills" "commands" "plugins")

# Migrate old-style top-level symlinks (e.g., ~/.config/opencode/agents -> dist/agents)
for cat in "${SUBDIRS[@]}"; do
    cat_path="$CONFIG_DIR/$cat"
    if [ -L "$cat_path" ]; then
        link_target="$(readlink -f "$cat_path")"
        expected_target="$(readlink -f "$DIST_DIR/$cat")"
        if [ "$link_target" = "$expected_target" ]; then
            echo "MIGRATE: replacing top-level symlink $cat_path -> $link_target with per-item symlinks"
            rm "$cat_path"
            mkdir -p "$cat_path"
        else
            echo "NOTE: top-level $cat_path is a symlink pointing elsewhere ($link_target). Leaving it." 
        fi
    fi
done

deployed_count=0
skipped_count=0
error_count=0
pruned_count=0
declared_items=()
config_linked=0
config_skipped=0
config_recorded=0

# Read profile file
while IFS= read -r line || [ -n "$line" ]; do
    # Trim leading/trailing whitespace
    entry="$line"
    entry="$(echo "$entry" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    # Skip blank and comment lines
    case "$entry" in
        ''|\#*)
            continue
            ;;
    esac
    declared_items+=("$entry")

    source_path="$DIST_DIR/$entry"
    target_path="$CONFIG_DIR/$entry"

    # Ensure parent dir exists
mkdir -p "$(dirname "$target_path")"

    if [ ! -e "$source_path" ] && [ ! -d "$source_path" ]; then
        echo "  MISSING: $entry -> $source_path (source does not exist). Skipping"
        skipped_count=$((skipped_count+1))
        continue
    fi

    if [ -L "$target_path" ]; then
        existing_target="$(readlink -f "$target_path")"
        expected_target="$(readlink -f "$source_path")"
        if [ "$existing_target" = "$expected_target" ]; then
            echo "  OK:     $entry -> already linked"
            skipped_count=$((skipped_count+1))
            continue
        else
            echo "  RELINK: $entry (was -> $existing_target)"
            rm "$target_path"
        fi
    elif [ -e "$target_path" ]; then
        # Real file or directory exists - check if it already points to our source
        existing_real="$(readlink -f "$target_path")"
        expected_source="$(readlink -f "$source_path")"
        if [ "$existing_real" = "$expected_source" ]; then
            echo "  OK:     $entry -> already present (via parent symlink)"
            skipped_count=$((skipped_count+1))
            continue
        fi
        echo "  ERROR:  $target_path exists and is not a symlink. Skipping."
        error_count=$((error_count+1))
        continue
    fi

    ln -s "$source_path" "$target_path"
    echo "  LINK:   $entry -> $source_path"
    deployed_count=$((deployed_count+1))
done < "$PROFILE_FILE"

# Prune stale symlinks from previous deployments that are no longer declared.
for cat in "${SUBDIRS[@]}"; do
    dir="$CONFIG_DIR/$cat"
    if [ ! -d "$dir" ]; then
        continue
    fi

    for entry in "$dir"/*; do
        [ -L "$entry" ] || continue

        raw_target="$(readlink "$entry")"
        case "$raw_target" in
            /*) target_path="$raw_target" ;;
            *) target_path="$(dirname "$entry")/$raw_target" ;;
        esac
        resolved_target="$(readlink -m "$target_path")"

        case "$resolved_target" in
            "$DIST_DIR"/*) ;;
            *)
                continue
                ;;
        esac

        rel="${entry#$CONFIG_DIR/}"
        keep=0
        for declared in "${declared_items[@]}"; do
            if [ "$declared" = "$rel" ]; then
                keep=1
                break
            fi
        done

        if [ "$keep" -eq 0 ]; then
            rm "$entry"
            echo "  PRUNE:  $rel (stale symlink -> $resolved_target)"
            pruned_count=$((pruned_count+1))
        fi
    done
done

BASE_CONFIG="$DIST_DIR/opencode.json"
TARGET_CONFIG="$CONFIG_DIR/opencode.json"

if [ -f "$BASE_CONFIG" ]; then
    expected_target="$(readlink -f "$BASE_CONFIG")"
    if [ -L "$TARGET_CONFIG" ]; then
        existing_target="$(readlink -f "$TARGET_CONFIG")"
        if [ "$existing_target" = "$expected_target" ]; then
            echo "  OK:     opencode.json -> already linked"
            config_skipped=1
            config_recorded=1
        else
            rm "$TARGET_CONFIG"
            ln -s "$BASE_CONFIG" "$TARGET_CONFIG"
            echo "  RELINK: opencode.json -> $BASE_CONFIG"
            config_linked=1
            config_recorded=1
        fi
    elif [ -e "$TARGET_CONFIG" ]; then
        echo "  ERROR:  $TARGET_CONFIG exists and is not a symlink. Skipping."
        error_count=$((error_count+1))
    else
        ln -s "$BASE_CONFIG" "$TARGET_CONFIG"
        echo "  LINK:   opencode.json -> $BASE_CONFIG"
        config_linked=1
        config_recorded=1
    fi
fi

# Write deployment record
RECORD_FILE="$CONFIG_DIR/.opencode-copilot-deployed"
{
    echo "# OpenCode Copilot deployment record"
    echo "# Profile: $PROFILE_NAME"
    echo "# Source: $DIST_DIR"
    echo "# Date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo "# BaseConfigLinked: $config_linked"
    echo "# BaseConfigSkipped: $config_skipped"
    if [ "$config_recorded" -eq 1 ]; then
        echo "opencode.json"
    fi
    for it in "${declared_items[@]}"; do
        echo "$it"
    done
} > "$RECORD_FILE"

echo ""
echo "Summary: deployed=$deployed_count skipped=$skipped_count pruned=$pruned_count errors=$error_count"
echo "Deployment record: $RECORD_FILE"
echo ""
echo "Done. Verify with: ls -la $CONFIG_DIR/"
