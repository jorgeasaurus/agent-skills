---
name: writing-and-communication
description: "Use for all prose outputs—progress updates, docs, explanations, landing copy, and markdown rewrites—to eliminate AI clichés and maximize clarity."
---

# Writing And Communication

## Anti-Slop Writing System (Orwell, STE & Google Style)

- Enforce Orwell's six rules on all prose (docs, PRs, messages) while leaving code and technical identifiers untouched: (1) never use stale metaphors or printed clichés; (2) prefer short words over long ones; (3) cut every cuttable word; (4) prefer active voice over passive; (5) use everyday English over jargon/foreign phrases where precision survives; (6) break any rule rather than write something barbarous (@Voxyz_ai, @mikehostetler).
- Follow ASD-STE100 Simplified Technical English and the Google Developer Documentation Style Guide for technical docs: dead-simple prose, no aphorisms, no flourishes, no cute/clever section titles, define every term before using it, and state explicitly what a doc covers and excludes (@zackkanter, @geogristle, @mikehostetler, @aaronvi).
- Ban filler copy, slogans, promotional adjectives, and unverified superlatives in docs and UI; run the swap test on product copy (if a competitor could paste a line unchanged, rewrite or delete it) (@AlpinDale, @Voxyz_ai, @JoePro).

## Banned Tells Check (`banned.md`)

- Maintain a concrete `banned.md` file with examples and direct replacements rather than vague instructions like `sound human`—build it from your own voice samples and add new tells the day they appear (@Zephyr_hg).
- Ban specific AI writing tells: `Quietly`, `It's not X, it's Y`, fake urgency deadlines (`before Monday`), addressing a generic crowd (`Most people...`), `can now X like a pro`, pseudo-deep closer lines (`That's the whole game`), rule-of-three slogans (`Write. Edit. Ship.`), piled adjectives (`powerful, seamless, game-changing`), and sirens/arrows/ALL-CAPS announcements (@Zephyr_hg).
- Run a mandatory pre-delivery self-check against `banned.md`: fix lines by stating what actually happened (never swap in a synonym), list which rules triggered, and apply a read-aloud check—if you wouldn't say it across a table, cut it (@Zephyr_hg).
- When rewriting existing prose into plain English, preserve every fact, name, number, link, file path, YAML frontmatter, and fenced code block; output only the rewritten text with no preamble (@Voxyz_ai, @hd_nvim / claudish-to-english).

## Progress Reports & Visual Explanations

- Report session progress in plain sentences: what changed, what failed, and what comes next; start with three lines and add detail only if it changes the next action—no emoji checkmarks, no `Successfully`, no `Perfect`, and no wall of bullets (@Voxyz_ai).
- Skip preambles and converse visually (`/show-me`) instead of walls of prose: pick the smallest view that clarifies—pseudocode, call trees, component trees, shallow file trees with one-line responsibilities, Mermaid sequence/state diagrams, `diff` blocks, types/signatures, or a focused single HTML explainer (@dexhorthy, @mattpocockuk).
- Include up to three concrete, costed next-step options at the end of deliverables when a user hasn't specified what comes next (skip for small edits or unattended runs) (@X1Kafadzhy / oil-ui).

## Teaching & Explanations

- For one-off learning explanations, explain extremely bottoms-up in plain, simple English so a reader gets it in one pass (@gabriel1).
- For ongoing mastery tutoring (`socratic-tutor`), run a 3–5 question diagnostic first, maintain an explicit 0–5 skill map, ask ONE question per turn and stop immediately without hints, prefer prediction/why/flaw-finding questions, play devil's advocate, avoid flattery, require 2+ independent checks (including unprompted recall) plus spaced review to level up, and emit `save state` / `resume from:` blocks for session handoffs (@RoundtableSpace / janestreet).
