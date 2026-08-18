---
name: mvp-activity-evidence
description: Build Microsoft MVP activity evidence from recent technical work. Use this skill when the user asks to update MVP activities, review GitHub/Vercel/blog impact for MVP submissions, turn recent posts or commits into MVP entries, or prepare contribution summaries for Microsoft MVP reporting.
---

# MVP Activity Evidence

Use this to turn recent public technical work into source-backed Microsoft MVP activity entries. The workflow is evidence-first: collect signals, confirm dates and URLs in the source systems, then write concise activity records.

## Inputs

Ask for or infer:
- Reporting window.
- Target activity format or destination, if any.
- Source roots: GitHub repos, blog repo/site, Vercel projects, session decks, newsletters, or community posts.
- Technology areas to classify against.

If the user names a source system, use that system directly when tools are available. Chronicle-style history is useful for discovery only; confirm important dates, URLs, traffic, and repository details in GitHub, Vercel, the blog repo, or the live site.

## Workflow

1. Define the reporting window.
   - Default to the period the user requested.
   - If no period is supplied, use the last 30 days and say so.

2. Inventory candidate activities.
   - GitHub: merged PRs, meaningful commits, releases, issues answered, docs added, samples shipped.
   - Blog/site: posts published, updated, or materially improved.
   - Vercel/analytics: traffic or usage signals that support reach, not vanity detail.
   - Presentations/community: talks, demos, workshops, repo examples, downloadable artifacts.

3. Filter aggressively.
   - Keep items with a public or auditable URL, a clear audience, and a Microsoft-relevant technology area.
   - Merge small related commits into one activity.
   - Skip private-only work unless the user explicitly wants an internal/private entry.

4. Confirm important facts at the source.
   - Date published or merged.
   - Canonical URL.
   - Repository or site name.
   - Measurable outcome, if available.
   - Technology area.

5. Draft entries.
   - Use concrete verbs: published, released, updated, answered, demonstrated, documented.
   - Prefer one compact paragraph per entry.
   - Include links and evidence notes separately if the target form has no URL field.

6. Reconcile duplicates.
   - Combine blog + code + deployment work only when they describe one coherent public contribution.
   - Keep separate entries when the audience or output is different.

## Output

Return a compact table unless the user requests a specific import format:

| Date | Activity | Technology area | Evidence | Notes |
| --- | --- | --- | --- | --- |

Then add:
- `Skipped`: candidates rejected and why.
- `Needs confirmation`: entries blocked by missing source access or ambiguous dates.

## Quality Bar

An entry is ready only when it has:
- A date or date range.
- A source URL or named auditable source.
- A specific contribution, not generic work history.
- A Microsoft ecosystem tie-in.
- A clear audience or impact signal.

Do not invent impact metrics. If analytics are unavailable, describe the output and audience, then mark reach as unconfirmed.
