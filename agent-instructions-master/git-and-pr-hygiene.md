---
name: git-and-pr-hygiene
description: "Use when staging files, writing Git commit messages, opening pull requests, or responding to code reviews."
---

# Git And Pr Hygiene

## Commit Messages

- Format commit messages with a capitalized subject line of 50 characters or less, no trailing period, followed by a blank line and a body wrapped at 72 characters (@zackkanter / tbaggery / cbeams).
- Write the subject line in imperative mood (`Fix bug`, matching `git merge`/`git revert`, not `Fixed bug` or `Fixes bug`) (@zackkanter / tbaggery / cbeams).
- Use the commit body to explain what changed and why—prior behavior, what was wrong, and why this approach was chosen—rather than restating how the diff works (@zackkanter / cbeams, @Voxyz_ai).
- Ban AI achievement hype in commits and PRs (`comprehensive`, `robust`, `reliable`, `seamless`); a reviewer should understand the change in one read (@Voxyz_ai).

## Repository Cleanliness & Build Artifacts

- Never commit build outputs (`dist/`), `.zip` archives, model weights, or profiling dumps; limit tracked binary assets to intentional icons, static web assets, or explicitly requested docs media (@AlpinDale).
- Run repository formatters, skill validators, and test suites before every commit (@joebell_ / AGENTS.md).

## PR Authoring & Merge Boundaries

- Agents open pull requests and get CI green, but never merge or enable auto-merge when repo rules reserve merging for maintainers (@joebell_ / AGENTS.md).
- Treat public repository commits, issues, and PR comments as permanently public—never include private context or secrets (@joebell_ / AGENTS.md).
- Contradiction note — PR descriptions & review replies: `@AlpinDale` forbids agents from writing PR descriptions or replying to reviewer comments (requiring the agent to hand facts to the user, and only writing on explicit user override with an override note in the PR), whereas `@Voxyz_ai` instructs agents to write plain-English PR descriptions. Follow repo `AGENTS.md` first; when permitted, state what changed and why in plain words without hype (@AlpinDale, @Voxyz_ai).
