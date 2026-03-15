# GitHub Community File Templates

Use these when scaffolding `.github/` for a new PowerShell module.

## FUNDING.yml

```yaml
github: {AuthorGitHub}
```

## SECURITY.md

```markdown
# Security Policy

## Reporting a Vulnerability

If you discover a vulnerability in {ModuleName}, please follow the process:

1. Go to the **Security** tab in the GitHub repository and click **"Report a vulnerability"** to create a private security advisory.
   - This ensures all communication remains private from the start.
2. A repo owner will be notified and can discuss the vulnerability privately with you.
3. We will evaluate the vulnerability and, if necessary, release a fix or mitigating steps to address it. We will contact you to let you know the outcome, and will credit you in the report.

   Please **do not disclose the vulnerability publicly** until a fix is released!

4. Once we have either a) published a fix, or b) declined to address the vulnerability for
whatever reason, you are free to publicly disclose it.
```

## PULL_REQUEST_TEMPLATE.md

```markdown
# Pull Request

## Type of Change

- [ ] 📖 Documentation
- [ ] 🪲 Fix
- [ ] 🩹 Patch
- [ ] ⚠️ Security Fix
- [ ] 🚀 Feature
- [ ] 💥 Breaking Change

## Issue
<!-- If this PR resolves an issue, enter the issue number here. -->

## Description
<!-- Please include a clear description of what your pull request does. -->

## Checklist

- [ ] 🕵️ I have reviewed my code for errors and tested it.
- [ ] 🚩 My pull request does not contain multiple types of changes.
- [ ] 📄 By submitting this pull request, I confirm that my contribution is made under the terms of the project's associated license.
```

## ISSUE_TEMPLATE/bug-report.md

```markdown
---
name: Bug Report
about: Submit a new bug
title: '🪲 Bug report'
labels: bug
assignees: {AuthorGitHub}
---

### Expected Behavior

### Current Behavior

### Possible Solution

### Steps to Reproduce

1.
2.
3.

### Context (Environment)
* Operating System and version as reported by `$PSVersionTable.OS`:
* PowerShell versions as reported by `$PSVersionTable.PSEdition`:

### Detailed Description
```

## ISSUE_TEMPLATE/feature_request.md

```markdown
---
name: Feature Request
about: Suggest an idea for this project
title: '🙏 Feature request'
labels: 'enhancement'
assignees: ''
---

### Description

### Describe the solution you'd like

### Describe any alternatives you've considered

### Additional context
```

## WORKFLOW-TRIGGERS.md

```markdown
# CI/CD Workflow Triggers

## Prerequisites

- Git installed and configured
- GitHub CLI (`gh`) installed (optional, for manual triggers)

## Quick Reference

| Scenario           | Command                                    | Jobs Run                       |
| ------------------ | ------------------------------------------ | ------------------------------ |
| Push to any branch | `git push origin <branch>`                 | build (3 OS)                   |
| Open PR            | `gh pr create --base main`                 | build (3 OS)                   |
| Release            | `git tag v1.0.0 && git push origin v1.0.0` | build, publish, release        |
| Manual             | `gh workflow run "CI/CD Pipeline"`         | build (3 OS)                   |

## Monitoring

```bash
gh run list
gh run watch
gh run view <run-id>
```
```
