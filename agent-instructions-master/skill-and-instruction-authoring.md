---
name: skill-and-instruction-authoring
description: "Use when writing or maintaining AGENTS.md, CLAUDE.md, DESIGN_RULES.md, or SKILL.md files and reusable agent workflows."
---

# Skill And Instruction Authoring

## Structure, Frontmatter & Size Caps

- Put house rules once in global `CLAUDE.md` / `AGENTS.md` (cross-repo defaults) and layer project-specific rules in repo-level `CLAUDE.md` or `DESIGN_RULES.md` (@Voxyz_ai, @Y0urDumble, @jonathan_wilke).
- Follow the Agent Skills layout: one folder per skill (`skills/<name>/SKILL.md` + optional `references/`), starting YAML frontmatter with `name` and a `description` containing clear `Use when ...` triggers (plus exclusions for non-matching tasks), and string-only `metadata` values (@joebell_ / AGENTS.md, @RoundtableSpace / janestreet).
- Keep each `SKILL.md` body under 500 lines and 5,000 words, offload deep details to `references/*.md` loaded on demand, verify all local links resolve, and avoid `#anchor` targets (@joebell_ / AGENTS.md).
- Validate skills automatically before commits (formatting, strict skill-check linting, and snippet/behavioral tests) (@joebell_ / AGENTS.md).

## Writing Effective Rules

- Prefer explicit negative bans (`No X`) paired with concrete examples and numbers (e.g., `<300ms`, `scale(0.96)`) over vague adjectives (`make it elegant`, `smooth`, `sound human`) (@jonathan_wilke / eliakuratli, @Zephyr_hg).
- Grow rule files iteratively from friction: every time an agent commits an annoying tell or bug, add a one-line rule with the reason why right next to it (@jonathan_wilke / eliakuratli, @Zephyr_hg).
- Support safe overrides and fast modes: include explicit user-override semantics (`when the user asks for X...`) and lightweight paths for quick prototypes (@AlpinDale, @X1Kafadzhy / hallmark).

## Teaching, Reuse & Security Hygiene

- Turn repeated visual or multi-step browser tasks into reusable skills by screen-recording a demonstration, then schedule them as event-driven or recurring routines (@nateherk).
- Read third-party skill repositories before installing them, because skills are executable instructions/code that run with your agent's permissions (@Y0urDumble).
- Keep unrelated repo drift out of scope: report stale skill/context warnings rather than fixing them unasked during an unrelated task (@X1Kafadzhy / impeccable).
