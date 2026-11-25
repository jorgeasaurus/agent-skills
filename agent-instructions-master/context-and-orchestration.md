---
name: context-and-orchestration
description: "Use when managing agent context windows, multi-session workflows, memory boundaries, model routing, or multi-agent teams."
---

# Context And Orchestration

## Session & Context Window Hygiene

- Keep sessions short, break complex jobs into small tasks, and start fresh sessions frequently; ask a new session to reference the previous session or pass a compact `save state` block (@zoedotai, @RoundtableSpace / janestreet).
- Maintain an explicit decision log during long refactors or multi-step runs so context compaction never loses architectural rationale (@mazeincoding / untangle-codebase).
- Load skill/reference files progressively on demand (`Read only relevant references`) rather than preloading every file into context (@joebell_ / apple-web-app, @X1Kafadzhy / oil-ui / ui-ux-pro-max).

## Memory & Knowledge Persistence

- Separate shared knowledge (company/project facts, tools, shared rules) from private agent-level memory, and state explicitly which level new facts belong to (@nateherk).
- Persist confirmed repo-specific facts (working test/build commands, required env vars, generated paths) after repeated confirmation—and prune stale ones when contradicted—so sessions stop rediscovering them (@CodeByNZ / TokenEconomizer).
- Keep projects, tasks, owners, and blockers logged in an external tracker (e.g., ClickUp, canonical sheet) so work does not vanish inside chat threads (@nateherk, @tomosman).

## Model Routing, Tool Pruning & Delegation

- Split advisor and executor roles: pair a stronger advisor model (`/advisor`) or high-reasoning planner with a faster/cheaper executor or medium-tier subagents (@zoedotai, @EXM7777).
- Use one Chief-of-Staff front-door agent that reads narrow specialist descriptions, delegates to the right specialist first, executes only when no specialist fits, and audits current goals to propose non-redundant team roles (@nateherk).
- Prune unused tool definitions per workspace/task so irrelevant schemas aren't sent on every turn, and detect repeated identical failure loops (e.g., 3x same error) to force a different approach (@CodeByNZ / TokenEconomizer).
- Use heartbeat or scheduled background monitors for long-running async jobs, notifying relevant threads only when human attention is required (@pvncher).
