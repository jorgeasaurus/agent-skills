---
name: planning-and-alignment
description: "Use before writing code or starting a multi-step task: clarify goals, run structured interviews, choose reasoning effort, and lock down specs or contracts first."
---

# Planning And Alignment

## Goal Alignment & Clarifying Questions

- Restate the user's goals and the underlying problem in your own words before executing complex or ambiguous work (@poteto).
- Run a structured interview (`/grill-me`) before planning, automation, or major builds until shared understanding is reached; during onboarding, invite unstructured context dumps (e.g., voice transcripts) and ask targeted follow-up questions to turn ideas into actions (@EXM7777, @nateherk, @utxo__).
- During execution, infer defaults from project context first and ask only what blocks correct execution or changes commercial, legal, security, privacy, or approval outcomes—bundle blocking questions into a single grouped turn (@JoePro, @joebell_, @jshguo / vercel design.md).
- Confirm intent with one short question before launching an interactive multi-turn workflow (such as tutoring or a deep refactor) when a user might only want a quick answer (@RoundtableSpace / janestreet).
- Be thorough in analysis and bold in recommendations; exercise abstract thinking when evaluating logic or architecture (@theo, @tanishqk).

## Spec-First & Contract-Driven Workflow

- Follow a staged pipeline for non-trivial builds: interview (`/grill-me`) -> specification (`/to-spec`) -> discrete tickets (`/to-tickets`) -> subagent implementation (`/implement`), or write an explicit shot/feature contract before execution (@EXM7777, @Y0urDumble, @tomosman).
- Define code shape—types, function signatures, component trees, and call stacks—before writing implementation code (@dexhorthy / show-me).
- Do not delete routes or component trees in an existing project without an explicit file-level plan approved by the user (@X1Kafadzhy / hallmark).
- Keep manual human steps strictly to browser-only provisioning (creating API keys, spinning up servers, buying domains), then hand access to the agent to configure, harden, deploy, and optimize (@karpathy).

## Reasoning Effort & Prioritization

- Use high/xhigh reasoning for new builds, specs, and architectural planning; use medium effort as the default for routine implementation, subagents, fixes, and re-renders (@EXM7777, @Y0urDumble, @karpathy).
- Respect strict decision priorities when constraints compete: (1) preserve supplied facts, formulas, units, privacy, and constraints; (2) preserve the host framework and conventions; (3) make the core answer and evidence clear; (4) apply brand/system rules; (5) tailor composition; (6) refine details (@jshguo / vercel design.md).
- Contradiction note — upfront interview vs minimal questions: run exhaustive interviews during planning/onboarding (`@nateherk`, `@utxo__`), but minimize interruptions during execution by inferring obvious defaults and grouping only blocking questions (`@jshguo`, `@joebell_`).
