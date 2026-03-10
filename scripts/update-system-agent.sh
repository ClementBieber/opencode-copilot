#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
AGENT_FILE="$PROJECT_DIR/dist/agents/system.md"

if [ ! -f "$AGENT_FILE" ]; then
    printf 'ERROR: agent file not found: %s\n' "$AGENT_FILE" >&2
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    printf 'ERROR: python3 is required to update %s\n' "$AGENT_FILE" >&2
    exit 1
fi

trim() {
    local value="$1"
    value="${value#${value%%[![:space:]]*}}"
    value="${value%${value##*[![:space:]]}}"
    printf '%s' "$value"
}

join_backticked() {
    local result=""
    local item
    for item in "$@"; do
        if [ -n "$result" ]; then
            result+=", "
        fi
        result+="\`$item\`"
    done
    printf '%s' "$result"
}

linux_distribution() {
    if command -v lsb_release >/dev/null 2>&1; then
        lsb_release -ds | tr -d '"'
        return
    fi

    if [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        printf '%s %s\n' "${NAME:-Unknown Linux}" "${VERSION:-}"
        return
    fi

    printf 'Unknown Linux\n'
}

tool_version() {
    local tool="$1"
    if ! command -v "$tool" >/dev/null 2>&1; then
        return 1
    fi

    local output
    case "$tool" in
        python3)
            output="$(python3 --version 2>&1)"
            printf '%s' "${output#Python }"
            ;;
        nix)
            output="$(nix --version 2>&1)"
            printf '%s' "${output##* }"
            ;;
        bun)
            bun --version
            ;;
        git)
            output="$(git --version 2>&1)"
            printf '%s' "${output#git version }"
            ;;
        node)
            output="$(node --version 2>&1)"
            printf '%s' "${output#v}"
            ;;
        zsh)
            output="$(zsh --version 2>&1)"
            printf '%s' "${output##* }"
            ;;
        bash)
            output="$(bash --version 2>&1 | python3 -c 'import sys; print(sys.stdin.readline().split()[3])')"
            printf '%s' "$output"
            ;;
        *)
            "$tool" --version 2>&1 | python3 -c 'import sys; print(sys.stdin.readline().strip())'
            ;;
    esac
}

repo_root="$(git -C "$PROJECT_DIR" rev-parse --show-toplevel 2>/dev/null || printf '%s\n' "$PROJECT_DIR")"
workspace_root="$repo_root"
kernel="$(uname -srmo)"
distribution="$(trim "$(linux_distribution)")"
bash_path="$(command -v bash)"
bash_version="$(tool_version bash)"

available_tools=()
missing_tools=()
for tool in python3 nix bun git; do
    if version="$(tool_version "$tool" 2>/dev/null)"; then
        available_tools+=("$tool $version")
    fi
done

for tool in node zsh; do
    if command -v "$tool" >/dev/null 2>&1; then
        version="$(tool_version "$tool")"
        available_tools+=("$tool $version")
    else
        missing_tools+=("$tool")
    fi
done

branch="$(git -C "$repo_root" branch --show-current 2>/dev/null || true)"
remote_url="$(git -C "$repo_root" remote get-url origin 2>/dev/null || true)"

git_context='- Git context: not a git repository'
if [ -n "$branch" ] || [ -n "$remote_url" ]; then
    git_context='- Git context:'
    if [ -n "$branch" ]; then
        git_context+=" repo on branch \`$branch\`"
    else
        git_context+=" repository with detached or unknown branch"
    fi
    if [ -n "$remote_url" ]; then
        git_context+=" with remote \`origin\` -> \`$remote_url\`"
    fi
fi

layout_items=()
for path in "$repo_root"/*; do
    [ -e "$path" ] || continue
    name="$(basename "$path")"
    if [ -d "$path" ]; then
        layout_items+=("$name/")
    else
        layout_items+=("$name")
    fi
done

layout_display="$(join_backticked "${layout_items[@]}")"
available_display="$(join_backticked "${available_tools[@]}")"

section_file="$(mktemp)"
trap 'rm -f "$section_file"' EXIT

{
    printf '## Known Environment\n\n'
    printf '%s\n' '- This section contains current observed host/repo facts and should be refreshed with `./scripts/update-system-agent.sh` when the environment changes.'
    printf -- '- Host OS: %s on %s\n' "$distribution" "$kernel"
    printf -- '- Primary shell available: `bash` %s via `%s`\n' "$bash_version" "$bash_path"
    if [ "${#missing_tools[@]}" -gt 0 ]; then
        printf -- '- Not currently available on PATH: %s\n' "$(join_backticked "${missing_tools[@]}")"
    fi
    printf -- '- Common tools confirmed: %s\n' "$available_display"
    printf -- '- Workspace root: `%s`\n' "$workspace_root"
    printf '%s\n' "$git_context"
    printf -- '- Top-level project layout includes %s\n' "$layout_display"
    printf '\nTreat these as strong defaults, but re-check when a task depends on exact runtime state.\n'
} > "$section_file"

python3 - "$AGENT_FILE" "$section_file" <<'PY'
from pathlib import Path
import sys

agent_path = Path(sys.argv[1])
section_path = Path(sys.argv[2])
text = agent_path.read_text()
section = section_path.read_text().rstrip() + "\n\n"

marker = "## Known Environment\n"
start = text.find(marker)
if start == -1:
    raise SystemExit(f"ERROR: could not find {marker.strip()} in {agent_path}")

next_header = text.find("\n## ", start + len(marker))
if next_header == -1:
    raise SystemExit(f"ERROR: could not find following section header after {marker.strip()} in {agent_path}")

updated = text[:start] + section + text[next_header + 1:]
agent_path.write_text(updated)
PY

printf 'Updated %s\n' "$AGENT_FILE"
