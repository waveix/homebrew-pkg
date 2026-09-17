# List available commands
default:
    @just --list

alias help := default

IGNORE_DIRS := '-name "vendor" -o -name "node_modules" -o -name ".git" -o -name "dist" -o -name "build" -o -name "out" -o -name "bin" -o -name "pkg" -o -name ".cache"'

export AGENTS_TEMPLATE := '''
# AGENTS.md

All conventions for this folder live in **[`README.md`](./README.md)** — the single
source of truth for people and agents alike.

**Before adding or editing anything here, read [`README.md`](./README.md) — and if it has a
[For Agents](./README.md#for-agents) section, follow that too.**

Don't duplicate the README here — extend the README instead.
'''

# Init git-hooks and autoupdate checks lint, fmt, etc.
[group('System')]
init:
    @pre-commit install
    @pre-commit autoupdate

    @git submodule update --init --recursive

# Check all files
[group('System')]
lint:
    @pre-commit install
    @pre-commit run --all-files

# Check tools
[group('System')]
tools:
    pre-commit --version

    docker -v
    docker buildx version
    hadolint -v

# Create AGENTS.md next to every README.md (skips existing)
[group('LLM')]
gen-agents:
    #!/usr/bin/env bash
    set -euo pipefail
    template="$(printf '%s' "$AGENTS_TEMPLATE")"
    find . -type d \( {{ IGNORE_DIRS }} \) -prune -o -name "README.md" -print0 | {
        created=0
        while IFS= read -r -d '' r; do
            f="$(dirname "$r")/AGENTS.md"
            if [ ! -e "$f" ]; then
                printf '%s\n' "$template" > "$f"
                echo "📝 Created: $f"
                created=$((created + 1))
            fi
        done
        if [ "$created" -eq 0 ]; then echo "📭 Every README.md already has an AGENTS.md."
        else echo "✅ Created $created AGENTS.md file(s)."; fi
    }

# Init files for Claude Code
[group('LLM')]
gen-cc: gen-agents
    #!/usr/bin/env bash
    set -euo pipefail
    find . -type d \( {{ IGNORE_DIRS }} \) -prune -o -name "AGENTS.md" -print0 | {
        while IFS= read -r -d '' a; do
            l="$(dirname "$a")/CLAUDE.md"
            ln -sf AGENTS.md "$l"
            echo "🔗 Linked: $l"
        done
    }
    echo "✅ All links for Claude Code generated successfully."

# Remove generated AGENTS.md and CLAUDE.md links
[group('LLM')]
clear-cc:
    #!/usr/bin/env bash
    set -euo pipefail
    template="$(printf '%s' "$AGENTS_TEMPLATE")"
    cleaned=0
    while IFS= read -r -d '' l; do
        rm -f "$l"; echo "🧹 Removed link: $l"; cleaned=$((cleaned + 1))
    done < <(find . -type d \( {{ IGNORE_DIRS }} \) -prune -o -name "CLAUDE.md" -type l -print0)
    while IFS= read -r -d '' a; do
        if [ "$(cat "$a")" = "$template" ]; then
            rm -f "$a"; echo "🧹 Removed: $a"; cleaned=$((cleaned + 1))
        else
            echo "⏭️  Kept (custom): $a"
        fi
    done < <(find . -type d \( {{ IGNORE_DIRS }} \) -prune -o -name "AGENTS.md" -print0)
    if [ "$cleaned" -eq 0 ]; then echo "📭 Nothing to clean."
    else echo "🧹 Cleaned $cleaned file(s)."; fi
