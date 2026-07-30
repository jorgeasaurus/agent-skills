---
name: thermonuclear-review-fix-loop
description: Drive a code change to a clean result by running the thermo-nuclear code-quality review, fixing every actionable finding, and repeating the review until it returns no findings. Use whenever the user asks to thermonuclearly review and fix code, resolve every thermonuclear-review finding, or keep iterating on code quality until the strict review is clean.
---

# Thermonuclear Review Fix Loop

Use this as a convergence loop, not as a one-pass review. The completion condition is a fresh thermo-nuclear review with zero findings, backed by relevant tests or checks.

## Scope and setup

1. Read the repository instructions and inspect the working tree. Preserve unrelated user changes.
2. Review the requested change or, if no scope is supplied, the current branch diff against its merge base. Do not silently widen the scope to pre-existing unrelated debt.
3. Identify the project's fastest relevant validation commands before editing. Keep the initial review output as the baseline for the loop.

## Convergence loop

Repeat these steps until the exit criteria are satisfied:

1. Run the `thermo-nuclear-code-quality-review` skill on the current scope. Apply its full strictness: look for structural regressions, missed code-judo simplifications, condition sprawl, weak boundaries, unnecessary abstractions, and file-growth problems.
2. Normalize the results into a numbered list of distinct, actionable findings. Each finding needs evidence, affected files, and a concrete remedy. Do not manufacture findings, and do not treat cosmetic preferences as blockers.
3. If there are no findings, run the relevant tests, type checks, lint, or build for the modified code. If those pass, finish.
4. Fix every finding in the current list. Prefer the simplest structural remedy that removes the root cause over suppressions, comments, casts, wrapper layers, or cosmetic edits.
5. Verify each batch with the narrowest relevant checks, then inspect the diff to confirm behavior and scope remain intact.
6. Start a fresh review round. Never declare a finding fixed based only on the earlier review; the next review decides whether the new design introduced or left behind a problem.

## Finding discipline

- Address the review's actual concern, not merely its wording. If a finding exposes a design flaw, restructure the design rather than patching its symptom.
- Group tightly related findings by root cause, but ensure every reported finding has been resolved or is explicitly covered by the shared fix.
- Do not disable rules, add blanket exceptions, lower test coverage, or dismiss findings as subjective just to reach a clean review.
- Do not recursively invoke this skill. Invoke `thermo-nuclear-code-quality-review` for each review round.
- If a review repeatedly reports the same finding after a genuine attempted fix, stop, reassess the root cause, and choose a different design. Do not churn the code or falsely claim convergence.

## Legitimate stopping conditions

Finish only when a newly run thermo-nuclear review returns **no findings** and the relevant validation passes.

If a finding requires a product decision, external credential, migration, destructive action, or other authority not implied by the request, pause and report the exact blocker. Do not call the review clean. If validation fails, keep working unless the failure is demonstrably unrelated; then report the evidence and the remaining risk.

## Final report

Report the review rounds, the root causes removed, files changed, and the final review and validation commands/results. State `Clean: yes` only after the final zero-finding review.
