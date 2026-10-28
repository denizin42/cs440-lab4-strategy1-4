# Project Context: CS 440 Lab 4 — Vacuum Robot Reinforcement Learning

## 1. Architecture & Problem Overview
This repository configures **Context Engineering Strategy 1 (Write)** and **Strategy 4 (Isolate)** for the CS 440 Lab 4 Vacuum Robot project.

> **Phase 1 Scope Note:** Per Lab 4 instructions, this repository provides the **Context Engineering scaffolding only**; the Python Q-Learning solution is intentionally not implemented yet (`src/README.md`).

### 4x4 Vacuum Grid World Specification
```text
Row \ Col    0        1        2        3
   0      [start]  [  0  ]  [  0  ]  [  0  ]
   1      [  0  ]  [  X  ]  [  0  ]  [  0  ]
   2      [  0  ]  [  0  ]  [  0  ]  [  0  ]
   3      [  0  ]  [ -1  ]  [  0  ]  [ +10 ]
```
- **Start State `(0, 0)`**: Top-left corner (initial cell value `0`).
- **Obstacle `X` at `(1, 1)`**: Impassable wall/pillar; attempting to move into `(1, 1)` or outside the 4x4 boundary keeps the robot in its current state.
- **Terminal Trap `-1` at `(3, 1)`**: Hazard state yielding reward `-1.0` and ending the episode.
- **Terminal Recharge Goal `+10` at `(3, 3)`**: Goal state yielding reward `+10.0` and ending the episode.
- **Standard Cells `0`**: Non-terminal cells yielding the step/living cost.

### Domain Rules: Unknown $T$ and $R$ (Model-Free RL Mandate)
- Unlike Lab 3 (Offline MDP Value Iteration), **we do NOT have the transition model $T(s, a, s')$ or the reward function $R(s, a, s')$**.
- When implementing the agent in Phase 2, the learner MUST NOT access private environment transition probabilities or reward tables directly. All learning must happen through sampled transitions $(s, a, r, s', \text{done})$.

---

## 2. Coding Standards (Strategy 1: Project Memory — Slide 22)
- Use Python 3.10+ with explicit PEP 484 type annotations.
- Use descriptive variable names (`learning_rate_alpha`, `discount_gamma`, `exploration_epsilon`) rather than single-letter abbreviations.
- Keep environment simulation state strictly encapsulated from the learning agent.
- Write deterministic unit tests using seeded random number generators before committing code.

---

## 3. Sub-Agent Delegation Rules (Strategy 4: Context Isolation — Slides 33–34)
You are the **Main Claude Agent (Orchestrator)**. To prevent **Context Confusion** and **Context Poisoning**, do not mix broad mathematical research, coding, and security/encapsulation code reviews in a single monolithic conversation history.

Instead, delegate specialized work through the **Context Filter** to the isolated sub-agents defined with YAML frontmatter in `.claude/agents/`:

1. **`code-reviewer` (`.claude/agents/code-reviewer.md`)**:
   - **Scoped Context**: Receives **ONLY** the code diff (`git diff`) and security/encapsulation focus.
   - **Purpose**: Verify that the learning agent never reads hidden $T$ or $R$ matrices and that terminal state boundaries are respected.
2. **`researcher` (`.claude/agents/researcher.md`)**:
   - **Scoped Context**: Receives **ONLY** broad architectural queries regarding Q-learning Bellman updates, convergence conditions, and exploration vs. exploitation strategies.
   - **Purpose**: Synthesize mathematical specifications without polluting the main coding context.

```javascript
// Code review agent - focused context (Slide 34)
Task(
  description: "Code review",
  prompt: "Review this PR focusing only on security, performance, and model-free T/R encapsulation",
  subagent_type: "code-reviewer"
)

// Research agent - broad architectural query (Slide 34)
Task(
  description: "Research implementation",
  prompt: "Compare epsilon-greedy vs optimistic exploration f(u,n)=u+k/n for the 4x4 vacuum grid",
  subagent_type: "researcher"
)
```

---

## 4. Dynamic Context Imports (Strategy 1: Write — Slides 21, 23, 25)
@./context/environment.md
@./context/q-learning.md
@./context/exploration.md
