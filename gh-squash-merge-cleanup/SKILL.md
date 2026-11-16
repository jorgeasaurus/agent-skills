---
name: gh-squash-merge-cleanup
description: Squash and merge a GitHub PR, then remove merged branches and disposable Vercel preview deployments in the current repository/project while preserving main, production, and dev-marked resources. Use for squash-and-merge or post-merge cleanup requests.
---

# Squash, Merge, and Clean Up

Complete the merge and cleanup together. Target the current repository and its verified linked Vercel project only; never sweep an account or organization. Creating or editing this skill does not execute it.

## Authorization and retention

A request to use this workflow authorizes its merge and ordinary post-merge cleanup; do not ask again for those actions. Show the concrete keep/delete/blocked inventory before deletion as a progress update. Restrict scope further when the user requests it.

Preserve resources whenever any keep rule matches:

- Branches: `main`, the repository default branch, the configured production branch, and `production`/`prod`.
- Deployments: every production-target deployment, the current production alias target, rollback targets, and deployments associated with a preserved branch. Historical production deployments also stay.
- Dev markers: case-insensitive `dev` or `development` as a complete name or delimiter-separated token (`/`, `-`, `_`, `.`), such as `dev`, `feature/dev-api`, or `app-dev`. Read branch names, related PR labels, deployment environment names, aliases, and explicit label/tag metadata. `device` and `developer` alone are not dev markers. A dev-labeled PR protects its head branch and linked deployments.
- Explicitly retained/protected resources. Missing production/branch/alias metadata is a classification blocker, not evidence that a resource is disposable.

Git branches have no native labels; inspect their names and associated PR labels. Do not infer markers from PR prose, log text, or arbitrary metadata. Capture branch-to-PR/deployment associations before deleting refs so orphaned previews retain their provenance.

## Inventory and merge

1. Confirm GitHub authentication, repository, PR, head SHA, base, worktree status, and all worktrees. Attach the PR to the current task when the attachment tool is available.
2. Paginate remote branches, relevant PR history (including labels), and deployments. Resolve the Vercel project/team from existing linkage or repository/deployment metadata; do not create/relink a project or infer identity from a similar name.
3. Check the latest-head required checks, mergeability, unresolved actionable reviews, and any explicitly requested review gate. Wait for pending checks in intervals of at most 60 seconds. Never bypass branch protection or use admin merge to conceal failures.
4. Squash against the observed SHA:

   ```bash
   gh pr merge "$PR_NUMBER" --repo "$REPOSITORY" --squash --match-head-commit "$HEAD_SHA"
   ```

5. Verify `MERGED` and record the squash SHA. An already-merged PR can proceed directly to cleanup; a closed unmerged PR cannot. A moved head requires fresh checks.
6. If production deployment is configured, verify the production deployment for the squash SHA (or a later main descendant containing it) is ready and healthy before deleting previews. A pending/failed production deployment blocks preview cleanup, not reporting the successful merge.

Use existing git authorship defaults. Do not add an agent co-author or enable auto-merge and then claim the merge happened.

## Branch cleanup

Aim to leave only retained branches. Classify other branches as deletable only when their exact tip is contained in the current base, or a same-repository merged PR records that exact head SHA. Squash merges require PR evidence; ancestry alone is insufficient.

- Delete the merged PR head and other proven-merged non-retained branches, locally and on the repository remote. Never delete branches in a contributor's fork.
- Open PRs, closed-unmerged PRs, and new remote commits after merge block remote deletion. Unique local commits, dirty worktrees, and active-task worktrees block local deletion; they do not block deletion of an independently proven-merged remote tip. Preserve previews associated with any such unfinished work. Report blockers explicitly; discarding unmerged work requires specific user authorization.
- Refresh each remote tip and retention metadata immediately before deletion. Delete the exact observed tip with a lease; a mismatch requires reclassification:

  ```bash
  git push "$REMOTE" --force-with-lease="refs/heads/$BRANCH:$TIP_SHA" ":refs/heads/$BRANCH"
  ```

- Move this task off its feature branch before removing the local ref. Leave a dirty current worktree untouched and report its local cleanup blocked. For a clean current worktree, switch to main and fast-forward only; if main is checked out elsewhere, detach the clean current worktree at the fetched main tip instead. Never stash/reset user work or switch another active task's checkout.
- Check the local tip independently. Use `git branch -d -- "$BRANCH"`; use `-D` only when exact-tip merged-PR evidence proves a squash-merged tip safe. Remove only clean, inactive disposable worktrees with `git worktree remove`, never force removal. Worktree cleanup must not erase untracked or ignored user files.

## Preview cleanup

For the linked Vercel project, delete non-retained preview deployments whose provenance is known and whose branch/PR has no unmerged or active work. Include old/orphaned previews when merged-PR history establishes their origin. Keep previews for blocked branches and list these as cleanup blockers.

Reinspect each deployment immediately before deleting it: verify project/team, environment, branch, dev markers, and aliases. Production protection overrides a `preview` target when a deployment has been promoted or currently serves production. Cancel an eligible queued/building preview before deletion; never cancel a production/dev deployment.

Use exact deployment IDs with the authenticated connector/API or:

```bash
vercel remove "$DEPLOYMENT_ID" --scope "$VERCEL_SCOPE" --yes
```

**Never pass a project name to `vercel remove`, and never delete a project.** `--safe` alone is not a retention policy. Preview aliases can disappear with their disposable deployment; never remove/reassign production or dev aliases to make deletion possible. Never expose credentials in output.

Confirm CLI options against installed help or the official [remove](https://vercel.com/docs/cli/remove), [list deployments](https://vercel.com/docs/rest-api/deployments/list-deployments), and [delete deployment](https://vercel.com/docs/rest-api/deployments/delete-a-deployment) documentation. If no Vercel project is linked, report preview cleanup as not applicable; unavailable access is blocked, not not-applicable.

## Verification and completion

Re-enumerate branches and deployments with pagination. Confirm deleted IDs/refs are absent, retained resources remain, and production is healthy. Treat an already-absent resource as success only after confirming its scoped identity. On uncertain errors, reread state before retrying; never broaden deletion scope.

Report PR URL, squash SHA, deleted branches/deployment count, retained main/production/dev resources, and every blocker. Claim “only main/production/dev remain” only when the final inventory proves it. Unmerged work, protections, missing access, or unclear provenance can leave cleanup incomplete; finish independent safe cleanup and state the remainder precisely.
