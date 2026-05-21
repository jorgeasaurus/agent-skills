---
name: powershell-nasa-power-of-ten-review
description: Review and refactor PowerShell code using NASA/JPL Power of Ten principles adapted for scripts, modules, automation, and endpoint-management tooling.
---

# PowerShell NASA Power of Ten Review Skill

## Purpose

Use this skill to review, generate, or refactor PowerShell code so it is predictable, testable, maintainable, and safe for automation.

This is especially useful for scripts that touch Intune, Microsoft Graph, SCCM, Jamf, FleetDM, CI/CD pipelines, infrastructure, production endpoints, or bulk operations.

## PowerShell-Specific Principles

### 1. Keep control flow simple

Prefer readable, linear logic.

Avoid:

- Deep nesting
- Hidden flow through dot-sourcing side effects
- Excessive scriptblock indirection
- Implicit pipeline behavior where explicit loops are clearer
- Broad `try/catch` blocks around too much code

Prefer:

```powershell
if (-not $InputObject) {
    throw "InputObject is required."
}
```

over complex nested conditionals.

### 2. Bound loops and pagination

Every loop should have a clear termination condition.

For Graph, REST APIs, retries, and pagination, require:

- Max retry count
- Backoff strategy
- Timeout or cancellation behavior
- Protection against infinite `@odata.nextLink` loops

Example:

```powershell
$maxPages = 500
$pageCount = 0

while ($nextLink) {
    $pageCount++

    if ($pageCount -gt $maxPages) {
        throw "Pagination exceeded max page limit of $maxPages."
    }

    $response = Invoke-MgGraphRequest -Uri $nextLink -Method GET
    $nextLink = $response.'@odata.nextLink'
}
```

### 3. Avoid uncontrolled runtime state

Avoid unnecessary global state, mutable script-scoped variables, or hidden module state.

Avoid:

```powershell
$global:TenantId = $TenantId
```

Prefer passing values explicitly through parameters.

### 4. Keep functions small

Each function should do one thing.

A good PowerShell function should usually have:

- One clear purpose
- A focused parameter set
- Minimal nesting
- Explicit output
- No surprise writes to host, files, or global state

Split large functions into helpers such as:

```powershell
Get-GraphPage
Invoke-GraphRequestWithRetry
Test-GraphResponse
Write-OperationLog
```

### 5. Use assertions, validation, and guard clauses

Use parameter validation and early exits.

Prefer:

```powershell
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$PolicyName
)
```

Use guard clauses:

```powershell
if (-not $PolicyName) {
    throw "PolicyName cannot be empty."
}
```

For destructive operations, require explicit confirmation support:

```powershell
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param()
```

### 6. Minimize variable scope

Declare variables near where they are used.

Avoid large top-level variable blocks that make state hard to track.

Prefer:

```powershell
foreach ($device in $devices) {
    $deviceId = $device.id
    Remove-IntuneDevice -Id $deviceId
}
```

### 7. Check every important return value

Never assume API calls succeeded.

Check:

- HTTP status
- Response body
- Null results
- Error records
- Partial failures
- Batch response failures
- Graph throttling responses
- Empty collections

For Graph batch calls, inspect every subresponse.

```powershell
foreach ($item in $batchResponse.responses) {
    if ($item.status -lt 200 -or $item.status -gt 299) {
        throw "Batch request $($item.id) failed with status $($item.status)."
    }
}
```

### 8. Avoid clever dynamic code

Avoid:

- `Invoke-Expression`
- Runtime-generated function names
- Hard-to-debug scriptblock magic
- Excessive aliases
- Implicit positional parameters in production code

Prefer explicit commands and named parameters.

```powershell
Get-ChildItem -Path $Path -File
```

instead of:

```powershell
gci $Path
```

### 9. Be careful with object mutation and references

PowerShell objects are easy to mutate accidentally.

Avoid modifying input objects unless clearly documented.

Prefer creating new objects:

```powershell
[pscustomobject]@{
    Id          = $Device.Id
    Name        = $Device.DisplayName
    Compliant   = $Device.ComplianceState
}
```

### 10. Treat warnings and analyzer findings as defects

Generated or reviewed code should pass:

```powershell
Invoke-ScriptAnalyzer -Path . -Recurse
```

Prefer fixing:

- Unapproved verbs
- Unused variables
- Positional parameters
- Aliases
- Missing `SupportsShouldProcess`
- Global variable usage
- Inconsistent casing
- Broad catches
- Null-comparison order issues

## PowerShell Review Checklist

Check for:

- `SupportsShouldProcess` on destructive functions
- `-WhatIf` support where appropriate
- Mandatory parameters where needed
- `[ValidateNotNullOrEmpty()]`
- Explicit error handling
- No swallowed exceptions
- Bounded retries
- Bounded pagination
- No `Invoke-Expression`
- No unnecessary globals
- No production aliases
- No unbounded `while ($true)`
- No blind bulk deletes
- Graph throttling handling
- Batch response validation
- Log messages that are useful but do not leak secrets
- Secrets never written to host, logs, or errors
- Cross-platform-safe paths where possible
- PowerShell 7 compatibility unless Windows PowerShell is required

## Preferred Function Pattern

```powershell
function Invoke-SafeOperation {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    if (-not $Name) {
        throw "Name is required."
    }

    $target = "Resource '$Name'"

    if (-not $PSCmdlet.ShouldProcess($target, "Invoke safe operation")) {
        return
    }

    try {
        $result = Invoke-SomeCommand -Name $Name -ErrorAction Stop
    }
    catch {
        throw "Failed to invoke operation for '$Name'. $($_.Exception.Message)"
    }

    if (-not $result) {
        throw "Operation returned no result for '$Name'."
    }

    return $result
}
```

## Output Format

When reviewing PowerShell code, respond with:

### Summary

State whether the code is safe, risky, or acceptable with caveats.

### Findings

```text
Severity: Critical | High | Medium | Low
Rule: Power of Ten #<number>
PowerShell concern: <specific issue>
Why it matters: <risk>
Fix: <recommended change>
```

### Suggested Patch

Provide corrected PowerShell code.

### Final Verdict

State whether it is ready, needs changes, or needs deeper redesign.

## Default PowerShell Style

Prefer:

- PowerShell 7
- Named parameters
- Splatting for readability
- Guard clauses
- Small functions
- `SupportsShouldProcess`
- `-ErrorAction Stop`
- Explicit `try/catch`
- `Invoke-ScriptAnalyzer`
- Cross-platform-safe paths
- No aliases in production code
- Clear object output

Avoid:

- Deep nesting
- Silent failures
- `Write-Host` for normal output
- `Invoke-Expression`
- Hidden globals
- Unbounded loops
- Catch-all error suppression
- Massive monolithic scripts
- Destructive operations without `-WhatIf`
