---
name: debugging-and-investigation
description: "Use when hunting bugs, diagnosing production or device issues, auditing state transitions, or requesting targeted fixes."
---

# Debugging And Investigation

## Hypothesis-Driven Investigation

- Work from plain user symptoms without forcing the user to name internal files, logs, or registries; turn the scenario into a falsifiable question and form a hypothesis before reading logs (@PJ_Marcum / intune-advanced-troubleshooting).
- Build a single correlated timeline across logs, state, config, and events; identify the exact owning engine, process, or code path rather than guessing (@PJ_Marcum).
- Hunt reported-vs-actual contradictions: distrust status markers written before the underlying work completes, and verify conclusions against a second independent signal (@PJ_Marcum).
- Escalate diagnostic depth autonomously (logs -> live trace -> source/decompilation) when lighter tiers leave the mechanism unproven; label anything unproven as an open question (@PJ_Marcum).

## State-Machine & Parallel Bug Hunts

- Document all explicit and implicit state machines (states, invariants, transition tables) in one file; hunt reachable invalid states or transitions—especially via retries and concurrency—with concrete evidence, prioritize by impact, group fixes into issues, fix with regression tests, and keep the doc updated (@trevin, @steveruizok).
- Fan out parallel reviewers to hunt real bugs across the codebase, adversarially verify each finding to drop false positives, and rank confirmed bugs by severity with a concrete fix plan (@gregor_suttie).

## Surgical Revision Prompts

- Scope targeted fixes explicitly using four fields—`WHERE` (exact files/frames/range), `PROBLEM` (measured symptom), `CHANGE` (exact delta), and `KEEP` (invariants and surrounding behavior not to touch)—then re-verify the affected slice (@Y0urDumble).
- Adopt a harsh external critic persona (`You did not make this`) to inspect outputs against requirements, list every flaw with exact locations, fix the worst 3 issues, and repeat (@Y0urDumble).
