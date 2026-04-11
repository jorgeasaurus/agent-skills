---
name: powershell-code-review
description: Production-readiness code review for PowerShell scripts and modules using Elon Musk's 5-Step Design Process. Use when auditing PowerShell code for Fortune 100 enterprise environments. Ruthlessly eliminates unnecessary code, challenges every abstraction, and produces a structured markdown report covering critical issues, recommended deletions, security risks, and production readiness.
---

# PowerShell Code Review

Conduct production-readiness audits of PowerShell scripts and modules for Fortune 100 enterprise environments. Apply Elon Musk's 5-Step Design Process to eliminate waste, simplify logic, and harden code — in that order.

## Review Philosophy

Apply the 5 steps **in order**. Do not skip ahead.

| Step | Principle | Action |
|------|-----------|--------|
| 1 | **Make requirements less dumb** | Challenge every requirement. Who signed off on this? Why does it exist? |
| 2 | **Delete** | Most critical step. Remove everything that cannot justify its existence. |
| 3 | **Simplify / Optimize** | Only after deletion. Never optimize what should not exist. |
| 4 | **Accelerate cycle time** | Does this code enable faster iteration or create bottlenecks? |
| 5 | **Automate** | Last step only. Never automate what should be deleted. |

> **Default to deletion.** Prove code must exist — don't assume it should.

See [review-philosophy.md](references/review-philosophy.md) for the full elimination target list and challenge checklist.

## Workflow

### 1. Receive Code

Accept PowerShell code as:
- Inline paste
- File path reference
- GitHub URL

### 2. Apply the 5-Step Process

Work through each step before moving to the next:

**Step 1 — Question requirements**
- Who defined this requirement?
- What breaks if this code does not exist?
- Is this solving a real problem or a hypothetical one?

**Step 2 — Delete**
Ruthlessly eliminate (see full list in [review-philosophy.md](references/review-philosophy.md)):
- Parameters that are "nice to have"
- Functions wrapping single cmdlets without adding value
- Defensive checks masking design flaws
- Comments explaining bad code (rewrite instead)
- `Begin`/`End` blocks where `Process` alone suffices
- Helper functions used in only one place
- Code that exists "just in case"

**Step 3 — Simplify**
After deleting, simplify what remains:
- Replace loops with pipeline operations where appropriate
- Replace string building with here-strings
- Replace custom formatting with `Format-Table`/`Format-List`
- Remove abstraction layers with no real reuse

**Step 4 — Accelerate**
- Does this pattern slow down future changes?
- Are there N+1 API call patterns?
- Is object materialization blocking streaming?

**Step 5 — Automate**
- Is this something a build/CI pipeline should handle instead?
- Are there manual steps that should be automated?

### 3. Categorize Issues

Review across all categories:

| Category | Focus |
|----------|-------|
| **Correctness & Logic** | Bugs, flawed assumptions, data flow errors, Graph/API call accuracy |
| **Security** | Credentials, tokens, input validation, injection risks, least privilege |
| **Performance** | Redundant calls, N+1 patterns, unnecessary materialization |
| **PowerShell Best Practices** | Naming, `[CmdletBinding()]`, pipeline design, error handling |
| **Cross-Platform** | PowerShell Core compatibility, OS-specific isolation |
| **Error Handling & Logging** | Terminating vs non-terminating, structured errors, no generic catches |
| **Maintainability** | SRP, DRY/KISS/YAGNI, readability without comments, guard clauses |

See [review-philosophy.md](references/review-philosophy.md) for per-category checklists.

### 4. Produce the Report

Output a markdown report using the structure in [report-template.md](references/report-template.md):

```
## Critical Issues
## Recommended Deletions
## Recommended Enhancements
## Optional Improvements
## Risk Assessment
```

Save the report as `<ScriptName>-review.md` unless the user specifies a path.

## PowerShell Best Practices Quick Reference

### Naming
- Approved verbs only (`Get-Verb`)
- Singular nouns, PascalCase
- No aliases in scripts — always use full cmdlet and parameter names

### Functions
```powershell
function Verb-Noun {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )
    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Action')) {
            # implementation
        }
    }
}
```

### Error Handling
```powershell
# Prefer typed exceptions over generic catch
try {
    $result = Get-Item -Path $Path -ErrorAction Stop
}
catch [System.IO.FileNotFoundException] {
    $PSCmdlet.WriteError(
        [System.Management.Automation.ErrorRecord]::new(
            $_.Exception,
            'FileNotFound',
            [System.Management.Automation.ErrorCategory]::ObjectNotFound,
            $Path
        )
    )
    return
}
# Never swallow exceptions silently
```

### Output
- **Objects, not formatted text** — consumers decide how to display
- `PSCustomObject` for structured data
- `PassThru` pattern for action cmdlets
- `Write-Output` for data; `Write-Verbose`/`Write-Warning` for status

### Destructive Operations
```powershell
# Always ShouldProcess for operations that change state
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param()
process {
    if ($PSCmdlet.ShouldProcess($Target, 'Remove')) {
        Remove-Item -Path $Target -Force
    }
}
```

## Review Principles

- **No politeness tax** — Direct criticism accelerates improvement
- **Code over comments** — Self-documenting code beats explained bad code
- **Demand evidence** — Claims require proof (benchmarks, failure scenarios)
- **Question best practices** — Do they improve *this* code or just look good?
- **The best code is no code** — Every line is a liability until proven otherwise

## References

- **[review-philosophy.md](references/review-philosophy.md)** — Full elimination targets, per-category checklists, challenge questions
- **[report-template.md](references/report-template.md)** — Markdown report output template with section guidance
