#!/usr/bin/env bash
# ==============================================================================
# CS 440 Lab 4 — Strategy 1: Write (Safe Context Injection & Context Switcher)
# Reference: Agentic AI & Context Engineering Lecture (Slides 24–27)
#
# Key Architectural Decisions:
# 1. Separation of Concerns (Slide 27):
#    The hook registration belongs in `.claude/settings.json`, while the
#    branch- and query-based context selection logic lives in this shell script.
# 2. Idempotency Guard (Slides 24–25):
#    Uses `grep -qxF` before appending `@./context/*.md` imports to `CLAUDE.md`
#    so repeated prompts never duplicate imports or cause context window bloat.
# ==============================================================================

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"
BRANCH=$(git -C "$PROJECT_DIR" branch --show-current 2>/dev/null || echo "main")

# Read prompt from CLI argument ($1) or from Claude Code's JSON stdin payload
if [[ $# -gt 0 ]]; then
    PROMPT="$1"
elif [[ ! -t 0 ]]; then
    INPUT_PAYLOAD=$(cat)
    if command -v jq >/dev/null 2>&1; then
        PROMPT=$(echo "$INPUT_PAYLOAD" | jq -r '.prompt // ""' 2>/dev/null || echo "$INPUT_PAYLOAD")
    else
        PROMPT="$INPUT_PAYLOAD"
    fi
else
    PROMPT=""
fi

# Create CLAUDE.md if it doesn't exist (Slide 25)
touch "$CLAUDE_MD"

# Safe against duplicate imports: check with grep -qxF before appending (Slides 24–25)
add_context() {
    local context_ref="$1"
    grep -qxF "$context_ref" "$CLAUDE_MD" || echo "$context_ref" >> "$CLAUDE_MD"
}

# --- 1. Branch-based context selection (Slides 25 & 27) ---
case "$BRANCH" in
    feature/environment*|env/*)
        add_context "@./context/environment.md"
        cat "$PROJECT_DIR/.claude/context/environment.md"
        ;;
    feature/q-learning*|rl/*)
        add_context "@./context/q-learning.md"
        cat "$PROJECT_DIR/.claude/context/q-learning.md"
        ;;
    feature/exploration*|explore/*)
        add_context "@./context/exploration.md"
        cat "$PROJECT_DIR/.claude/context/exploration.md"
        ;;
esac

# --- 2. Query-based context selection (Slides 25 & 27) ---
if [[ -n "$PROMPT" ]]; then
    if echo "$PROMPT" | grep -Eiq 'grid|environment|obstacle|trap|recharge|slip|start'; then
        add_context "@./context/environment.md"
        cat "$PROJECT_DIR/.claude/context/environment.md"
    fi
    if echo "$PROMPT" | grep -Eiq 'q-learning|bellman|q-table|temporal|alpha|gamma|td'; then
        add_context "@./context/q-learning.md"
        cat "$PROJECT_DIR/.claude/context/q-learning.md"
    fi
    if echo "$PROMPT" | grep -Eiq 'explore|exploration|epsilon|greedy|regret|optimistic'; then
        add_context "@./context/exploration.md"
        cat "$PROJECT_DIR/.claude/context/exploration.md"
    fi
fi
