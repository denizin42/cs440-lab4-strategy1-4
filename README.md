# CS 440 Lab 4: Context Engineering Strategies 1 (Write) & 4 (Isolate)

**Group 2 Members:** David Jablonski (`@denizin42`), Chris Mills (`@chris-mills03`), James Richardson (`@RichardsonJC`)  
**Course:** CS 440 — Introduction to Artificial Intelligence (Fall 2026)

---

## 1. Purpose of This Repository (Scaffolding Only — Problem Not Solved Yet)

Per the updated **CS 440 Lab 4** requirements:
> *"Create one repository for context engineering strategies 1 and 4. The repository must contain all files with appropriate content."*

This repository sets up the **Claude Code Context Engineering scaffolding** (Strategies **1: Write** and **4: Isolate**) for the **4x4 Vacuum Robot Reinforcement Learning** problem. As instructed (*"we will solve it later, not today"*), no Python Q-Learning solution code is written yet (`src/README.md` serves as the placeholder for Phase 2).

### The Target Problem Configured in Context: 4x4 Vacuum Grid with Unknown $T$ and $R$

```text
Row \ Col    0        1        2        3
   0      [start]  [  0  ]  [  0  ]  [  0  ]
   1      [  0  ]  [  X  ]  [  0  ]  [  0  ]
   2      [  0  ]  [  0  ]  [  0  ]  [  0  ]
   3      [  0  ]  [ -1  ]  [  0  ]  [ +10 ]
```

- **Start State `(0, 0)`**: Top-left corner (initial reward `0`).
- **Obstacle `X` at `(1, 1)`**: Impassable wall/pillar.
- **Terminal Trap `-1` at `(3, 1)`**: Hazard yielding `-1.0`.
- **Terminal Recharge Goal `+10` at `(3, 3)`**: Goal yielding `+10.0`.
- **Why Q-Learning Instead of Lab 3's Value Iteration?** In Lab 3, $T(s, a, s')$ and $R(s, a, s')$ were known offline. In Lab 4, **$T$ and $R$ are unknown**, so our context files instruct the agent to use **Model-Free Tabular Q-Learning** via sampled experience tuples $(s, a, r, s', \text{done})$.

---

## 2. Repository Structure & File Map (For Team & Grader Review)

```text
cs440-lab4-strategy1-4/
├── README.md                                  # Team & grader walkthrough of Strategies 1 and 4
├── CLAUDE.md                                  # [Strategy 1 & 4] Project Memory + Main Orchestrator Task() rules
├── .claude/
│   ├── settings.json                          # [Strategy 1] Registers UserPromptSubmit hook -> context-switcher.sh
│   ├── context/                               # [Strategy 1] Context files echoed by context-switcher.sh (Slide 27)
│   │   ├── environment.md                     # 4x4 grid topology & unknown T/R boundary
│   │   ├── q-learning.md                      # Model-free Bellman TD update equation
│   │   └── exploration.md                     # Epsilon-greedy vs. exploration function f(u,n) = u + k/n
│   ├── skills/
│   │   └── q-learning-audit/
│   │       └── SKILL.md                       # [Strategy 1] On-demand procedural Skill (Slide 28)
│   └── agents/                                # [Strategy 4] Isolated Sub-Agents with YAML frontmatter (Slides 33–34)
│       ├── code-reviewer.md                   # Focused context: receives ONLY code diff & encapsulation rules
│       └── researcher.md                      # Broad context: receives ONLY architectural RL queries
├── context/                                   # [Strategy 1] Dynamic @./context/*.md imports in CLAUDE.md (Slides 25–26)
│   ├── environment.md
│   ├── q-learning.md
│   └── exploration.md
├── examples/
│   └── user-memory-CLAUDE.md                  # [Strategy 1] Reference example of ~/.claude/CLAUDE.md (Slide 23)
├── scripts/
│   └── context-switcher.sh                    # [Strategy 1] Branch + prompt selector with grep -qxF duplicate guard
└── src/
    └── README.md                              # Placeholder for Phase 2 Python implementation
```

---

## 3. How Strategy 1 (Write) Is Configured (Lecture Slides 21–28)

1. **Three-Tier Persistent Memory Hierarchy (Slides 21–23):**
   - **Project Memory ([`./CLAUDE.md`](./CLAUDE.md))**: Shared via Git; defines the 4x4 grid coordinates, coding standards, and the strict rule that $T$ and $R$ are unknown.
   - **User Memory ([`examples/user-memory-CLAUDE.md`](./examples/user-memory-CLAUDE.md) $\rightarrow$ `~/.claude/CLAUDE.md`)**: Personal developer preferences and workflow shortcuts that persist across sessions.
   - **Dynamic Context Imports (`@./context/*.md`)**: Modular domain files loaded on demand (`environment.md`, `q-learning.md`, `exploration.md`).
2. **Hook Registration vs. Selection Logic (Slides 24–27):**
   - **[`.claude/settings.json`](./.claude/settings.json)** registers the `UserPromptSubmit` hook (`bash "$CLAUDE_PROJECT_DIR/scripts/context-switcher.sh"`).
   - **[`scripts/context-switcher.sh`](./scripts/context-switcher.sh)** contains the selection logic, checking both the active Git branch (`feature/environment*`, `feature/q-learning*`, `feature/exploration*`) and user prompt keywords.
   - **Idempotency Safeguard (`grep -qxF`)**: Before appending `@./context/...` to `CLAUDE.md`, `add_context()` runs `grep -qxF "$context_ref" "$CLAUDE_MD" || echo "$context_ref" >> "$CLAUDE_MD"`, preventing duplicate imports and fatal context window bloat (Slides 24–25).
3. **Claude Code Skills ([`.claude/skills/q-learning-audit/SKILL.md`](./.claude/skills/q-learning-audit/SKILL.md) — Slide 28):**
   - Stores specialized verification procedures that Claude loads only when auditing Q-learning code.

---

## 4. How Strategy 4 (Isolate) Is Configured (Lecture Slides 33–34)

1. **Main Agent (Orchestrator — [`./CLAUDE.md`](./CLAUDE.md), Section 3):**
   - Acts as a manager that decomposes complex work and delegates tasks using `Task(description, prompt, subagent_type)` rather than crowding a single context window.
2. **Context Filter & Scoped Sub-Agents with YAML Frontmatter ([`.claude/agents/`](./.claude/agents/)):**
   - **[`.claude/agents/code-reviewer.md`](./.claude/agents/code-reviewer.md)**: Configured with YAML frontmatter (`name: code-reviewer`, `tools: ["Read", "Grep", "Glob"]`, `model: sonnet`). Receives **ONLY** code diffs and security/encapsulation rules to verify that the learner never accesses hidden $T$ or $R$ tables.
   - **[`.claude/agents/researcher.md`](./.claude/agents/researcher.md)**: Configured with YAML frontmatter (`name: researcher`, `tools: []`, `model: sonnet`). Receives **ONLY** broad architectural queries about Bellman TD updates and $\epsilon$-greedy vs. optimistic exploration $f(u, n) = u + k/n$. With no tools, it cannot read repository files, so the context filter is enforced rather than conventional.
   - This isolation prevents full conversation history from leaking between tasks, eliminating **Context Confusion** (Slide 33).
