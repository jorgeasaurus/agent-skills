---
name: architecture-and-refactoring
description: "Use when designing systems, refactoring codebases, reviewing abstractions, or managing code comments and repository files."
---

# Architecture And Refactoring

## Simplicity & First-Principles Design

- Optimize every change for simple purpose, simple architecture, simple design, and simple implementation; elevate user experience (UX), developer experience (DX), and agent experience (AX) together without regressions (@Voxyz_ai).
- Apply the deletion test to hunt shallow modules (whose interface changes whenever internals change), pass-through wrappers, speculative extension points, copy-pasted logic, and dead code—delete or merge them rather than adding layers (@mattpocockuk, @mazeincoding / untangle-codebase).
- Identify all compensating code and special cases (`if` branches for one caller, caller-specific flags, swallowed exceptions, arbitrary retries/sleeps, disabled tests), then redesign from first principles as if today's requirements were known from the start rather than patching special cases one by one (@mazeincoding).

## Coupling, Boundaries & Dependencies

- Organize around one rule: pieces that must change together belong together (colocated by domain), pieces that change for different reasons stay decoupled, and stable modules never import more volatile ones (@mazeincoding / untangle-codebase).
- Eliminate hidden links (duplicated rules that must stay in sync, implicit call orders, shared globals/files across modules) and leaked internals (@mazeincoding / untangle-codebase).
- Preserve the project's existing styling system, framework, file structure, and conventions; edit the files that naturally own the behavior and never introduce a second styling or framework layer (@jakubkrehel, @jshguo / vercel design.md).
- Use git history to see which files change together, script dependency graphs to check import direction, and summarize large repos via skeletons (stripping function bodies) or subagent summaries before refactoring (@mazeincoding / untangle-codebase).

## Comments & Repository Documentation

- Write comments only to explain external constraints, non-obvious invariants, or why a workaround exists; remove comments that restate implementation or record chat/task history (@AlpinDale, @mazeincoding / untangle-codebase).
- Update documentation only where user-facing usage changed, preferring short edits in existing sections over new README headlines or announcement sections for minor features (@AlpinDale).
- Do not scatter superfluous Markdown notes or task summaries through the repository; link to authoritative code and configuration instead of duplicating details (@AlpinDale).
