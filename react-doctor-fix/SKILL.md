---
name: react-doctor-fix
description: Fix React Doctor findings and keep a React codebase at a clean score. Use this skill when the user asks to run React Doctor, address React Doctor findings, restore a 100% React Doctor score, apply React Doctor recipes, or fix React code quality issues that are reported by a doctor-style checker.
---

# React Doctor Fix

Use this when a repository already has a React Doctor or similar React health checker workflow and the job is to drive findings to zero without broad rewrites.

## Workflow

1. Find the checker command.
   - Inspect `package.json`, task docs, CI workflows, and recent task notes.
   - Prefer the repo's existing script over guessing a command.
   - If no command exists, stop with the smallest missing prerequisite.

2. Establish the baseline.
   - Run the checker before edits.
   - Capture score, finding IDs, categories, files, and any recipe or documentation links.
   - If the report is long, group findings by root cause instead of fixing line by line.

3. Read the recipe before changing code.
   - Use the local report first.
   - If a finding references canonical docs or a recipe URL, inspect that source when network or browser tools are available.
   - Confirm whether the rule expects a behavior change, a component boundary change, a hook dependency fix, or a mechanical cleanup.

4. Patch in small batches.
   - Fix one category or root cause at a time.
   - Prefer existing component patterns, hooks, types, and test helpers.
   - Avoid disabling rules, adding wrapper abstractions, or changing unrelated UI behavior unless the finding requires it.
   - Preserve user edits and do not clean up unrelated files.

5. Verify after each meaningful batch.
   - Rerun React Doctor or the repo's equivalent checker.
   - Run targeted tests, type checks, lint, or build commands that cover the touched files.
   - If the score drops or new findings appear, stop and re-plan around the regression.

6. Finish only with evidence.
   - Target is a clean React Doctor score, normally `100%`, or a clear explanation of the remaining blocker.
   - Include before/after score, commands run, changed files, and any rule IDs that remain.
   - If the user also requested strict review, run the relevant code-review skill after React Doctor is clean.

## Triage Heuristics

- Duplicate findings in one component usually indicate one missing boundary or shared pattern.
- Hook findings are correctness-sensitive; reason about stale closures and render timing before editing dependencies.
- Component purity and derived-state findings usually want simpler data flow, not memoization everywhere.
- Accessibility or DOM findings need browser-visible verification when practical.
- Rule suppression is a last resort and should include a source-backed reason.

## Output

Report:

- `Baseline`: score and top finding categories.
- `Changes`: files and root causes fixed.
- `Verification`: commands run and final score.
- `Remaining`: blockers, if any, with exact rule IDs and next step.

Do not claim the score is clean unless the checker was rerun after the final edit.
