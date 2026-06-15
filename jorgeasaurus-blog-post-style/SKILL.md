---
name: jorgeasaurus-blog-post-style
description: Use this skill whenever the user asks to brainstorm, draft, edit, review, or publish a Jorgeasaurus blog post, especially posts about PowerShell, Intune, Microsoft Graph, endpoint management, automation, scripting patterns, or engineering practice. This skill captures Jorge's practical field-note style, MDX post structure, code-example standards, release checklist, social card expectations, and verification workflow.
---

# Jorgeasaurus Blog Post Style

Use this skill to create or revise posts for the Jorgeasaurus blog. The goal is not generic technical writing. The goal is a practical field note from an endpoint automation engineer who has lived with the operational consequences of the tools being described.

## Core Voice

Write like a senior engineer explaining the useful part to another capable engineer.

- Lead with the real operational pain.
- Keep paragraphs short.
- Prefer concrete examples over abstract explanation.
- Use direct claims, then prove them with code or workflow.
- Be opinionated, but not performative.
- Avoid corporate phrasing, hype, and tutorial filler.
- Let humor be dry and sparse.
- End with a checklist, reusable pattern, or practical next step.

Good Jorgeasaurus-style moves:

- "The fix is boring: use the same structure every time."
- "That is why script shape matters."
- "Output explains. Exit codes decide."
- "It is not clever. That is the point."

Avoid:

- Long intros about the modern IT landscape.
- Marketing-style value propositions.
- Over-explaining obvious PowerShell syntax.
- "In this comprehensive guide..." phrasing.
- Decorative analogies that do not help the implementation.
- Emoji.

## Post Shape

Most technical posts should follow this shape:

1. Frontmatter with `title`, `date`, `description`, and `tags`.
2. Short opening that names the pain.
3. A blunt thesis.
4. Sections organized around practical patterns, failure modes, or steps.
5. Code examples that are small enough to scan.
6. A testing or verification section when the post includes scripts.
7. A final checklist or reuse rules section.
8. References only when they add trust or unblock the reader.

Prefer headings that sound like advice:

- `Return Objects, Not Pretty Text`
- `Use Parameters Instead of Editing Variables`
- `Make Logging Predictable`
- `Write For SYSTEM Context`
- `Testing Checklist`
- `Reuse Rules`

Avoid vague headings:

- `Introduction`
- `Overview`
- `Deep Dive`
- `Conclusion`

## MDX Frontmatter

Use this format:

```md
---
title: "Post Title"
date: "YYYY-MM-DD"
description: "One practical sentence describing what the reader gets."
tags: ["powershell", "intune", "automation"]
---
```

Description style:

- One sentence.
- Practical outcome.
- No hype.
- Mention the target tool or domain when useful.

Tag style:

- Lowercase.
- Use existing site tags when possible: `powershell`, `intune`, `microsoft-graph`, `automation`, `windows`, `endpoint-management`, `scripting`, `tutorial`.

## Code Example Standards

PowerShell examples should be production-shaped even when small.

Prefer:

- `[CmdletBinding()]`
- typed parameters
- `ValidateNotNullOrEmpty()`
- splatting for long commands
- `try/catch` around boundaries
- explicit `exit 0` / `exit 1` where a management tool consumes the result
- `[pscustomobject]` output when data is meant for automation
- `Write-Output` for caller-facing status
- local log files for detailed troubleshooting
- comments only where they explain intent or operational behavior

Avoid:

- aliases in examples
- magic variables that require editing before every run
- broad `catch` blocks that hide useful failure
- string output when an object is more useful
- clever one-liners when readability matters

When writing endpoint-management scripts, explicitly consider:

- SYSTEM context
- `HKCU` versus real user hives
- 32-bit versus 64-bit PowerShell
- working directory assumptions
- mapped drives not existing
- idempotence
- logs that survive after the management agent exits

## Article Patterns

### Pattern Post

Use for posts like "PowerShell Patterns I Wish More Endpoint Engineers Used."

Structure:

```md
Opening pain.

Thesis sentence.

## Pattern One

Why it matters.

Bad or weak example.

Better example.

Short takeaway.

## Pattern Two
...

## Starter Skeleton

Reusable code.

## Final Checklist
```

### Troubleshooting Post

Use when the topic is "why is this broken?"

Structure:

```md
Name the symptom.

Explain the mental model.

## What Actually Happens

## Logs To Check

## Common Mistakes

## Known-Good Test Flow

## Troubleshooting Checklist
```

### Script Template Post

Use when publishing reusable scripts.

Structure:

```md
Pain and thesis.

## What The Tool Expects

## Detection / Query / Setup Script

## Action / Remediation / Export Script

## Deployment Settings

## Testing Checklist

## Reuse Rules

## References
```

## Social Card Expectations

When creating a new post, create a social card unless the user asks not to.

Use:

- `1200 x 630` PNG.
- Site visual language: dark glass panel, green terminal accent, Jorgeasaurus brand mark.
- Exact readable title text.
- A small code or terminal motif when relevant.
- No AI-generated text in raster images. Render title text deterministically with HTML/CSS or another reliable local method.

Store it at:

```text
public/images/posts/<slug>/socialcard.png
```

Register it in `src/content/posts.ts`:

```ts
socialImage: {
  src: '/images/posts/<slug>/socialcard.png',
  width: 1200,
  height: 630,
  type: 'image/png',
}
```

## Repo Workflow

When creating a post in `jorgeasaurus-blog`:

1. Add `src/content/<slug>.mdx`.
2. Add the post metadata to the top of `src/content/posts.ts`.
3. Add a social card under `public/images/posts/<slug>/socialcard.png`.
4. Run PowerShell snippet parsing for PowerShell-heavy posts.
5. Run `npm run lint`.
6. Run `npm run build`.
7. Browser-check the post route if a dev server is available.
8. Confirm generated HTML contains the expected `og:image` and `twitter:image`.
9. Stop any preview dev server that was started.

If the build regenerates `public/rss.xml`, keep that change.

## Verification Standards

Do not call a post release-ready until the relevant checks pass.

For PowerShell posts:

- Extract fenced `powershell` blocks and parse them with PowerShell.
- If runnable scripts are added, parse those `.ps1` files too.
- If the user tested scripts on an endpoint, mention that separately from syntax validation.

For site integration:

- `npm run lint`
- `npm run build`
- metadata inspection for new social card posts
- browser render check when practical

## Review Pass

Before finalizing, read the post like a staff engineer reviewing a field note:

- Does the opening name a real problem quickly?
- Does every section earn its place?
- Are code examples short enough to scan?
- Are operational caveats explicit?
- Does the post avoid generic tutorial filler?
- Is there a useful checklist, template, or next step?
- Are links official or clearly relevant?
- Does the title match the actual value delivered?

If something feels verbose, cut it. If something feels clever, make it boring and useful.
