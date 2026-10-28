# Personal Development Preferences (User Memory: `~/.claude/CLAUDE.md`)

> **Strategy 1 (Write — Slides 21 & 23):** In Claude Code's 3-tier memory hierarchy, User Memory resides at `~/.claude/CLAUDE.md` so personal preferences and workflow shortcuts persist across all user sessions. A reference copy is included here for Lab 4 review.

## Code Style
- Always use explicit return types and PEP 484 type annotations in Python.
- Use descriptive variable names (`learning_rate_alpha`, `discount_gamma`, `exploration_epsilon`), avoiding single-letter abbreviations.
- Prefer composition and dataclasses over untyped tuples.

## Workflow Shortcuts
- When writing tests in Phase 2, use `pytest` with deterministic random seeds (`seed=42`).
- Always run linters and tests before committing.
