---
name: market-data-freshness-review
description: Review and update market data files, data refresh scripts, scheduled workflows, and dashboards for freshness, source reliability, stale placeholders, and calculation correctness. Use this skill when the user asks to refresh market data, verify market data, compare data-source diffs, check dashboard share or valuation math, or confirm financial data is current rather than stale or fake.
---

# Market Data Freshness Review

Use this when a repo turns external market or valuation data into dashboards, static JSON, reports, or site UI. The goal is to prove the data is current enough, sourced clearly, and transformed correctly.

## Workflow

1. Locate the data path.
   - Identify static data files, update scripts, scheduled workflows, and UI/dashboard consumers.
   - Read existing README or task notes only for source intent, not as proof.
   - Find the generated-output contract before editing source data.

2. Classify every source field.
   - Source URL or API.
   - Last updated timestamp, if present.
   - Manual value, scraped value, derived value, cached value, or placeholder.
   - Consumer fields in the dashboard.

3. Verify source freshness.
   - Use live source checks when the user asked for current data or when stale data would affect the result.
   - Prefer primary sources, official pages, exchange/company pages, repository data, or the configured upstream source.
   - Use browser-backed fallback only when the configured API or source is missing, stale, or blocked.
   - Record the exact date checked.

4. Update data through the intended path.
   - Prefer the repo's refresh script or scheduled workflow logic over manual JSON edits.
   - If a source is stale, exclude it or mark it stale according to the existing schema instead of silently carrying it forward.
   - Preserve provenance fields and add them only when they fit the existing contract.
   - Keep manual overrides isolated and explained.

5. Review transformations.
   - Recompute split adjustments, share totals, vested and unvested shares, market caps, prices, percentages, and weighted values independently.
   - Check units: shares vs dollars, pre-split vs post-split, cents vs dollars, thousands vs millions.
   - Confirm rounding is intentional and consistent between scripts and UI.

6. Review automation.
   - Inspect scheduled workflows and update scripts for failure handling, source drift, rate limits, and atomic writes.
   - Confirm scripts fail loudly on invalid, missing, stale, or placeholder data.
   - Check that generated data includes enough provenance to diagnose future drift.

7. Review dashboard behavior.
   - Trace each displayed number to a source or calculation.
   - Run the project's build/test path when available.
   - For UI changes, use browser verification or screenshots when the app can run locally.

## Staleness Rules

- Do not call data current just because a file exists or a script ran.
- Do not use placeholder values as live values.
- Do not mix old and new source vintages without labeling the result `mixed`.
- If network, credentials, or paywalls block confirmation, mark the field `unverified` and name the blocker.
- If a fallback source is used, keep the configured source's failure visible in the notes.

## Output

Lead with findings if there are correctness risks. Otherwise report:

- `Data status`: current, stale, mixed, or unverified.
- `Source evidence`: URLs/files checked and dates.
- `Updates made`: scripts run, files changed, and source vintages.
- `Calculation checks`: values recomputed and whether they match.
- `Automation risks`: workflow/script issues.
- `Dashboard verification`: build/browser checks performed.
- `Open questions`: only facts that could not be confirmed from available sources.

Current means the configured source was checked, the source date is acceptable for the domain, and the transformed dashboard values reconcile with that source.
