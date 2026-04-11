# Review Philosophy

Detailed guidance for applying Elon Musk's 5-Step Design Process to PowerShell code reviews.

## The 5 Steps — In Order

Never skip a step. Never reorder them.

### Step 1 — Make Requirements Less Dumb

Every requirement was added by a person. People make mistakes. Question everything before writing a single line of code.

**Ask for every block of code:**
- Who defined this requirement?
- Why does this requirement exist?
- What is the worst-case outcome if it is removed?
- Is this solving a problem that has actually occurred, or one that might occur?
- Is this requirement cargo-culted from another system that had a different context?

**Common traps:**
- "We've always done it this way"
- "The security team requires it" (ask which specific threat it mitigates)
- "It's industry best practice" (does it apply to this context?)
- "We might need it later" (YAGNI — You Aren't Gonna Need It)

---

### Step 2 — Delete

This is the most important step. If you are not occasionally shocked by what you deleted, you are not deleting enough.

**The deletion test:** Remove the code. What breaks? If the answer is "nothing obvious," delete it.

#### Code Elimination Targets

##### Parameters
- Parameters that are "nice to have"
- Parameters that duplicate what the consuming cmdlet already handles
- `$Verbose`, `$Debug` parameters (use `[CmdletBinding()]` — these are inherited automatically)
- Optional parameters that default to the same behavior as not passing them

##### Functions
- Functions that wrap a single cmdlet without adding logic
- Helper functions used in exactly one place (inline the logic)
- Functions created for "future flexibility" that have no current callers
- `Begin`/`End` blocks where `Process` alone suffices
- Functions whose only purpose is to rename a cmdlet

##### Logic & Control Flow
- `try/catch` blocks that catch and re-throw without adding context
- `try/catch` blocks around code that cannot throw
- `if ($null -ne $x)` guards where `$x` is always initialized
- Empty `catch {}` blocks
- Redundant null checks before calling cmdlets that already handle null

##### Comments
- Comments that describe *what* the code does (the code should be self-documenting)
- TODO/FIXME comments that have existed for more than one sprint
- Commented-out code
- Comments that explain why a workaround exists for *internal* technical debt (fix the root cause instead); workarounds for external constraints — third-party bugs, API limitations, OS quirks — should remain documented

##### Abstractions
- Wrapper classes/objects around hashtables with no additional behavior
- Custom `PSCustomObject` where a hashtable suffices
- Interfaces and base classes with one implementation
- Generic utilities built for "reuse" that are only used once

##### Structural Waste
- `begin {}` and `end {}` blocks that only contain comments
- `process {}` blocks in scripts that don't accept pipeline input
- `return $null` at the end of a function
- `| Out-Null` where `[void]` or `$null =` is clearer
- Explicit `$true`/`$false` returns from boolean expressions
- `Write-Output` inside a function that already returns the value via the pipeline

---

### Step 3 — Simplify and Optimize

**Only simplify what survived deletion.** Never optimize code that should not exist.

#### Simplification Targets

| Pattern | Simplification |
|---------|----------------|
| `foreach` loop building an array | Pipeline with `Select-Object`, `Where-Object`, `ForEach-Object` |
| String concatenation in a loop | Here-string or `-join` operator |
| `switch` with two cases | `if`/`else` |
| Nested `if` blocks > 3 deep | Guard clauses (early return) |
| `$result = @(); foreach { $result += ... }` | `$result = ... | ForEach-Object { ... }` |
| Manual CSV/JSON parsing | `ConvertFrom-Csv`, `ConvertFrom-Json` |
| Custom format output | `Format-Table`, `Format-List`, `Select-Object` |
| Multi-line parameter splatting for 1–2 params | Inline parameters |

#### Never Nesting

Nested code is a maintenance tax. Use guard clauses instead:

```powershell
# Bad — nested
function Get-Thing {
    param($Path)
    if (Test-Path $Path) {
        if ($Path -match '\.ps1$') {
            # real work
        } else {
            Write-Error "Not a .ps1 file"
        }
    } else {
        Write-Error "Path not found"
    }
}

# Good — guard clauses
function Get-Thing {
    param($Path)
    if (-not (Test-Path $Path)) { $PSCmdlet.ThrowTerminatingError(...); return }
    if ($Path -notmatch '\.ps1$') { $PSCmdlet.ThrowTerminatingError(...); return }
    # real work
}
```

---

### Step 4 — Accelerate Cycle Time

Does this code make future changes faster or slower?

**Bottleneck patterns:**
- Functions with 10+ parameters (hard to call, hard to test)
- Tightly coupled logic that cannot be tested in isolation
- Hard-coded values that require a code change to update
- Global state (`$script:`, `$global:`) that creates ordering dependencies
- N+1 API call patterns (fetch one item, then loop to fetch details for each)
- Unnecessary object materialization blocking streaming output

**Pipeline streaming check:**
```powershell
# Blocks until all items are collected — slow for large sets
$items = Get-AllItems
foreach ($item in $items) { Process-Item $item }

# Streams — starts processing immediately
Get-AllItems | ForEach-Object { Process-Item $_ }
```

---

### Step 5 — Automate

Automate last. Never automate what should be deleted.

**Questions before automating:**
- Is this process already worth doing after steps 1–4?
- Is there a CI/CD tool that already handles this?
- Will automation hide a process that should be eliminated instead?
- Is the automation itself more complex than the manual step?

---

## Per-Category Review Checklists

### Correctness & Logic

- [ ] Do all code paths produce the expected output?
- [ ] Are API/Graph call parameters correct (scopes, filters, pagination)?
- [ ] Are type coercions explicit and intentional?
- [ ] Are date/time operations timezone-aware?
- [ ] Does pagination logic handle empty result sets?
- [ ] Are regex patterns anchored appropriately?
- [ ] Does the code handle the empty pipeline case?

### Security

- [ ] No credentials or secrets in plaintext
- [ ] No credentials in log output (even verbose)
- [ ] Tokens sourced from `$env:` or secret stores, never hardcoded
- [ ] Dynamic command construction (`Invoke-Expression`, `&`, `-EncodedCommand`) justified and sanitized
- [ ] Input validated before being used in file paths or command arguments
- [ ] `ShouldProcess` implemented for all destructive operations
- [ ] `ConfirmImpact` set appropriately (`High` for destructive, `Medium` for significant)
- [ ] Least-privilege: only requesting permissions actually needed
- [ ] No sensitive data written to disk without encryption

### Performance & Efficiency

- [ ] No redundant API or cmdlet calls within a loop
- [ ] No N+1 patterns (fetch list, then fetch each item individually)
- [ ] Collections streamed rather than materialized where possible
- [ ] `Select-Object` used server-side (OData `$select`) not client-side where supported
- [ ] `Where-Object` filtering done server-side where possible
- [ ] No `+=` to grow arrays in loops (use `[System.Collections.Generic.List[object]]`)

### PowerShell Best Practices

**Naming:**
- [ ] All verbs are approved (`Get-Verb`)
- [ ] Nouns are singular and PascalCase
- [ ] No aliases (`%`, `?`, `gci`, `echo`, etc.)
- [ ] Full parameter names used (no `-r` for `-Recurse`)

**Functions:**
- [ ] `[CmdletBinding()]` on all advanced functions
- [ ] Comment-based help present: `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`
- [ ] `ValueFromPipeline` and `ValueFromPipelineByPropertyName` used where appropriate
- [ ] `ValidateSet`, `ValidateRange`, `ValidatePattern` used where inputs are constrained
- [ ] `[OutputType()]` attribute present

**Output:**
- [ ] Functions return objects, not formatted strings
- [ ] `Write-Verbose` used for progress/status (not `Write-Host` in library code)
- [ ] `Write-Host` used only in interactive scripts where console output is the intent
- [ ] `PassThru` switch implemented for action cmdlets

**Error Handling:**
- [ ] `$PSCmdlet.ThrowTerminatingError()` used over bare `throw`
- [ ] `$PSCmdlet.WriteError()` used over `Write-Error`
- [ ] All `ErrorRecord` objects include `ErrorId`, `Category`, and `TargetObject`
- [ ] No generic `catch { Write-Error $_ }` — handle specifically or re-throw
- [ ] `$ErrorActionPreference = 'Stop'` set at script scope when appropriate

### Cross-Platform Compatibility

- [ ] No `$env:USERPROFILE` without `$env:HOME` fallback (or use `[Environment]::GetFolderPath()`)
- [ ] No `\` path separators hardcoded — use `Join-Path` or `[System.IO.Path]::Combine()`
- [ ] No Windows-only cmdlets (`Get-WmiObject`, `Get-EventLog`) without `#Requires -OS Windows` guard
- [ ] `pwsh` (Core) compatible — no .NET Framework-only APIs without version check
- [ ] Registry access isolated behind OS check

### Maintainability

- [ ] No function longer than ~50 lines without clear justification
- [ ] No nesting deeper than 3 levels (use guard clauses)
- [ ] No magic numbers or strings (use named variables or `ValidateSet`)
- [ ] Single Responsibility: each function does one thing
- [ ] DRY: no logic duplicated across functions
- [ ] YAGNI: no code for requirements that don't exist yet

---

## Challenge Questions

Ask these for **every** function, parameter, and block:

| Target | Challenge |
|--------|-----------|
| Any function | What breaks if this function is deleted? |
| Any parameter | What breaks if this parameter is removed? |
| Any `try/catch` | Does this add recovery logic or just hide the error? |
| Any comment | Why isn't the code self-documenting instead? |
| Any abstraction | Is this actually reused, or speculatively reusable? |
| Any validation | Does the consuming cmdlet already validate this? |
| Any `Begin/End` | Is there setup/teardown logic, or is `Process` sufficient? |
| Any custom object | Why not a hashtable? |
| Any pipeline bypass | Why isn't this using the pipeline? |
| Any helper function | Is this used more than once? If not, inline it. |
