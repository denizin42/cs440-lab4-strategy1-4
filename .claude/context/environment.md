# Environment Context (`@./context/environment.md`)

## 4x4 Vacuum Grid Coordinate Specification
- **Grid Dimensions**: `4 rows x 4 cols`, 0-indexed `(row, col)`.
- **Start State**: `(0, 0)` — Top-Left cell (`start`, value `0`).
- **Obstacle (`X`)**: `(1, 1)` — Impassable wall/pillar. Attempting to move into `(1, 1)` or outside the 4x4 boundary keeps the robot in its current state `s`.
- **Trap State (`-1`)**: `(3, 1)` — Terminal hazard yielding reward `-1.0`.
- **Recharge Goal (`+10`)**: `(3, 3)` — Terminal goal yielding reward `+10.0`.
- **Standard Cells (`0`)**: Non-terminal cells yielding the step/living cost.

## Black-Box Simulation Contract
- Because $T(s, a, s')$ and $R(s, a, s')$ are unknown to the learning agent, the agent must interact with the environment strictly as a black-box simulator when implemented in Phase 2.
