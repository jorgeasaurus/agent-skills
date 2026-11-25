---
name: verification-and-testing
description: "Use before declaring any task done: verify changes end-to-end, test rendered UIs in real browsers, maintain behavioral tests, and report checks honestly."
---

# Verification And Testing

## End-to-End & Loop Verification

- Always ask `How do we make this change fully verifiable?` and test end-to-end against real services, real builds, and real UI flows rather than stopping at unit mocks (@mattpocockuk).
- For broad app QA, inventory every feature from code into a single canonical tracking sheet with user stories and expected behavior, loop through testing every story and logging failures, fix logic/UX errors, and re-test every behavior post-fix (@tomosman).
- Verify visual work by rendering and inspecting screenshots (Playwright headless captures, light/dark modes, mobile 390px and desktop 1280/1440px, SVG-to-PNG renders, or contact sheets) rather than shipping blind code; replay animations at 10% speed and walk every state (@jonathan_wilke / eliakuratli, @Y0urDumble, @jakubkrehel, @X1Kafadzhy / impeccable / logo-design-skill).
- Batch visual inspections: inspect once, fix all visible issues together, then re-capture—do not loop one-off checks per tweak (@X1Kafadzhy / impeccable / hallmark).

## Test Quality & Failure Coverage

- Write tests against observable behavior rather than internal implementation details; remove tests that mirror implementation or cannot fail on regressions (@mazeincoding / untangle-codebase).
- Test and implement all interactive and failure states (default, hover, active/pressed, focus-visible, disabled, loading, error, empty, offline, partial/delayed data); never permit silent failures or unstyled default browser error states (@JoePro).

## Honest Reporting & Quality Gates

- Run every required test, build, lint, or benchmark directly; never skip checks with a caveat unless the runtime or hardware is genuinely unavailable, and never present inferred correctness or speedups as measured (@AlpinDale, @X1Kafadzhy / oil-ui).
- Never claim a visual or interactive pass when screenshots or a runnable environment were unavailable—explicitly label unverified checks (`Not verified` + reason) beside the verdict (@X1Kafadzhy / oil-ui / hallmark, @jakubkrehel).
- Label extracted measurements explicitly as `MEASURED`, `ESTIMATED`, or `DECISION`, and name exact locations/frames for uncertain items needing human review (@Y0urDumble).
- Structure UI/code review outputs as a single markdown table (`Severity | Location | Before | After | Why`) with a `Considered but Rejected` section, `Verification` results, and an explicit `Verdict` (`Block`, `Needs changes`, `Approve`) (@jakubkrehel, @X1Kafadzhy / emil-design-eng).
