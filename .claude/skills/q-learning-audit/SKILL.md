---
name: q-learning-audit
description: Specialized procedure for auditing future Vacuum Robot Q-Learning code to verify model-free T/R encapsulation and Bellman terminal state handling.
---

# Q-Learning Compliance & Bellman Audit Skill (Slide 28)

Load this skill on demand when implementing or reviewing Phase 2 Q-learning code:

1. **Verify Model-Free Encapsulation (Unknown $T$ and $R$)**:
   - Confirm the learning agent never reads private grid reward tables or slip probability matrices directly.
2. **Verify Terminal State Boundary**:
   - When `next_state` is the Trap `(3, 1)` (`-1`) or Recharge Goal `(3, 3)` (`+10`), the future value term $\max_{a'} Q(s', a')$ must be `0.0`.
3. **Verify Tie-Breaking**:
   - When all $Q(s, a) == 0.0$ initially, break ties randomly rather than biasing toward a single direction.
