#!/usr/bin/env bash
# deploy.sh - Create symlinks from ~/.config/opencode/ to dist/ files and dirs

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$PROJECT_DIR/dist"
CONFIG_DIR="$HOME/.config/opencode"
VERBOSE=0

usage() {
    echo "Usage: $0 [-v|--verbose]" >&2
}

log_detail() {
    if [ "$VERBOSE" -eq 1 ]; then
        echo "$1"
    fi
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        -v|--verbose)
            VERBOSE=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown arg: $1" >&2
            usage
            exit 2
            ;;
    esac
    shift
done

echo "Deploying OpenCode Copilot configs..."
echo "  Source: $DIST_DIR"
echo "  Target: $CONFIG_DIR"
echo ""

mkdir -p "$CONFIG_DIR"

# Categories
SUBDIRS=("agents" "skills" "commands" "plugins")

# Canonical deployed items.
# When adding a new globally deployed file or directory under dist/, add it here.
declared_items=(
    "agents/orchestrator.md"
    "agents/command.md"
    "agents/specialist.md"
    "agents/system.md"
    "agents/researcher.md"
    "agents/explore.md"
    "agents/general.md"
    "agents/compaction.md"
    "agents/summary.md"
    "agents/research-synthesizer.md"
    "agents/taskmaster.md"
    "skills/opencode-integration"
    "skills/development"
    "skills/task-management"
    "skills/project-architecture"
    "skills/last30days"
    "skills/research"
    "skills/delegation-protocol"
    "skills/publication"
    "skills/session-index"
    "skills/cost-aware-llm-pipeline"
    "skills/autonomous-loops"
    "skills/continuous-learning"
    "skills/mailing"
    "commands/init.md"
    "commands/command.md"
    "commands/overview.md"
    "commands/last30.md"
    "commands/mail.md"
    "commands/order.md"
    "commands/task.md"
    "commands/litterature.md"
    "plugins/compaction.ts"
)

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
config_linked=0
config_skipped=0
config_recorded=0

# Deploy canonical item list
for entry in "${declared_items[@]}"; do
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
            log_detail "  OK:     $entry -> already linked"
            skipped_count=$((skipped_count+1))
            continue
        else
            log_detail "  RELINK: $entry (was -> $existing_target)"
            rm "$target_path"
        fi
    elif [ -e "$target_path" ]; then
        # Real file or directory exists - check if it already points to our source
        existing_real="$(readlink -f "$target_path")"
        expected_source="$(readlink -f "$source_path")"
        if [ "$existing_real" = "$expected_source" ]; then
            log_detail "  OK:     $entry -> already present (via parent symlink)"
            skipped_count=$((skipped_count+1))
            continue
        fi
        echo "  ERROR:  $target_path exists and is not a symlink. Skipping."
        error_count=$((error_count+1))
        continue
    fi

    ln -s "$source_path" "$target_path"
    log_detail "  LINK:   $entry -> $source_path"
    deployed_count=$((deployed_count+1))
done

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
            log_detail "  PRUNE:  $rel (stale symlink -> $resolved_target)"
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
            log_detail "  OK:     opencode.json -> already linked"
            config_skipped=1
            config_recorded=1
        else
            rm "$TARGET_CONFIG"
            ln -s "$BASE_CONFIG" "$TARGET_CONFIG"
            log_detail "  RELINK: opencode.json -> $BASE_CONFIG"
            config_linked=1
            config_recorded=1
        fi
    elif [ -e "$TARGET_CONFIG" ]; then
        echo "  ERROR:  $TARGET_CONFIG exists and is not a symlink. Skipping."
        error_count=$((error_count+1))
    else
        ln -s "$BASE_CONFIG" "$TARGET_CONFIG"
        log_detail "  LINK:   opencode.json -> $BASE_CONFIG"
        config_linked=1
        config_recorded=1
    fi
fi

# Write deployment record
RECORD_FILE="$CONFIG_DIR/.opencode-copilot-deployed"
{
    echo "# OpenCode Copilot deployment record"
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
if [ "$VERBOSE" -eq 0 ]; then
    echo "Run with -v or --verbose to show per-item deployment details."
fi
echo "Deployment record: $RECORD_FILE"
echo ""
echo "Done. Verify with: ls -la $CONFIG_DIR/"
