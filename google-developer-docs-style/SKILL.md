---
name: google-developer-docs-style
description: "Write clear technical docs in Google's developer style."
version: 0.1.0
author: Jorge Suarez (jorgeasaurus), Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [documentation, technical-writing, Google, style-guide, accessibility]
    related_skills: []
---

# Google developer documentation style skill

Write technical documentation that is clear, direct, accessible, and useful to developers. Follow project-specific guidance first. Use Google's developer documentation style as the default when no stronger project rule applies.

## When to use

Use this skill when you:

- Write or edit README files, guides, tutorials, reference docs, or release notes.
- Write API descriptions, CLI help, code comments, or UI instructions.
- Review technical prose for clarity, tone, structure, or accessibility.
- Convert engineering notes into reader-facing documentation.

Do not use it to override legal, security, product, or project-specific terminology rules.

## Core rules

### Voice and tone

- Write in a friendly, conversational tone.
- Use a calm, direct voice.
- Address the reader as **you**.
- Use active voice. Name the person or system that performs the action.
- Avoid hype, vague claims, jokes, and unnecessary apologies.
- Do not pre-announce content. Start with the instruction or answer.
- Use present tense for current behavior.
- Use sentence case for headings and titles.
- Prefer short sentences and familiar words.

Prefer:

```text
Run the build script to create the module package.
```

Avoid:

```text
The module package will be created by running the build script.
```

### Global and accessible language

- Write for readers who might not share your culture or first language.
- Explain jargon the first time you use it.
- Define an abbreviation before using its shortened form.
- Avoid idioms, slang, metaphors, and region-specific expressions.
- Use inclusive language.
- Do not use ableist, violent, or exclusionary terms when a neutral term works.
- Do not rely on color alone to convey meaning.
- Give links descriptive text. Do not use `click here`.
- Add useful alternative text for images and diagrams.
- Make procedures usable with a keyboard when documenting interfaces.

### Sentence and paragraph structure

- Put conditions before instructions.
- Put the most important information first.
- Keep one main idea per sentence.
- Keep paragraphs focused on one topic.
- Use concrete subjects and verbs.
- Remove words that do not change the meaning.
- Use serial commas.
- Use standard American spelling unless the project says otherwise.

### Procedures

Use a numbered list for a sequence of actions. Introduce the procedure with context when needed.

1. Start each step with an imperative verb.
2. Put one user action in each step.
3. Keep steps in the order the reader performs them.
4. Use substeps for choices or detail inside one action.
5. State the expected result when it helps the reader verify progress.
6. Put conditions before the action they control.

Example:

```markdown
To build the module, follow these steps:

1. Open a PowerShell 7 session.
2. Run `./build.ps1 -Task Build`.
3. Confirm that `build/IntuneHydrationKit/` contains the package.
```

### Headings and organization

- Use sentence case.
- Make headings describe the content below them.
- Keep heading levels in order.
- Do not skip from `##` to `####`.
- Use lists for parallel items.
- Use tables only when readers need to compare values.
- Put prerequisites before procedures.
- Put troubleshooting near the procedure it supports.
- End long documents with verification or next steps.

## Code and interface text

- Put commands, filenames, paths, parameters, functions, variables, and code in backticks.
- Use fenced code blocks for multiline code.
- Mark the language on fenced code blocks when possible.
- Make examples complete enough to run or clearly label placeholders.
- Use angle brackets for placeholders, such as `<tenant-id>`.
- Explain non-obvious flags and output.
- Use bold for visible UI controls, such as **Save** or **Next**.
- Match the product's exact capitalization for UI labels and API names.
- Use descriptive link text.

Example:

```powershell
./build.ps1 -Task Test
```

The command runs the test task and reports the result in the terminal.

## Reference documentation

- Describe what a command, function, or parameter does before listing edge cases.
- Use consistent parameter names.
- State required and optional values.
- State defaults.
- State side effects and limits.
- Use present tense for behavior.
- Use precise verbs such as `returns`, `creates`, `deletes`, and `requires`.
- Do not make claims such as `fast`, `easy`, or `best` without evidence.

## Editing procedure

1. Identify the reader and the task.
   - Completion check: the document has one clear reader goal.
2. Apply project-specific style and terminology.
   - Completion check: project rules do not conflict with the edit.
3. Rewrite the opening so it gives the reader useful information immediately.
   - Completion check: no pre-announcement remains.
4. Replace passive voice, vague verbs, jargon, and unnecessary words.
   - Completion check: each sentence has a clear subject and action.
5. Convert sequences into numbered procedures.
   - Completion check: each step contains one main action.
6. Format code, UI labels, links, lists, and headings consistently.
   - Completion check: readers can distinguish prose, code, and controls.
7. Check accessibility and global readability.
   - Completion check: no color-only meaning, unexplained abbreviation, or unclear link text remains.
8. Verify technical accuracy.
   - Completion check: commands, paths, defaults, and outputs match the source code or tool output.

## Review checklist

- [ ] The first paragraph states the purpose or gives the next action.
- [ ] The document uses a friendly, direct tone.
- [ ] The document uses second person where appropriate.
- [ ] Active voice names the actor.
- [ ] Headings use sentence case.
- [ ] Conditions appear before instructions.
- [ ] Procedures use numbered steps.
- [ ] Code and UI labels use the correct formatting.
- [ ] Links use descriptive text.
- [ ] Abbreviations and jargon are explained.
- [ ] Language works for a global audience.
- [ ] Accessibility needs are addressed.
- [ ] Claims are precise and verifiable.
- [ ] Commands and examples were checked against the project.

## Source

This skill is based on the Google developer documentation style guide:

- https://developers.google.com/style
- https://developers.google.com/style/highlights
- https://developers.google.com/style/voice
- https://developers.google.com/style/procedures
- https://developers.google.com/style/accessibility

When the Google guide changes, reload the source pages and update this skill.
