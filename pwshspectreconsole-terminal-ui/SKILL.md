---
name: pwshspectreconsole-terminal-ui
description: Build polished, maintainable PowerShell 7 terminal user interfaces with the PwshSpectreConsole module, including Spectre.Console prompts, tables, markup, status spinners, progress bars, demo discovery, and safe fallbacks.
---

# PwshSpectreConsole Terminal UI Skill

## When to use this skill

Use this skill when the user wants to create, refactor, or review a PowerShell script or module that uses `PwshSpectreConsole` for terminal user interfaces.

Good matches include requests involving:

- Interactive PowerShell menus, selection prompts, confirmations, and text prompts.
- Terminal dashboards, tables, panels, rules, trees, grids, charts, calendars, or rich formatted output.
- Progress bars, status spinners, long-running task feedback, or background job visualization.
- Replacing `Write-Host`, `Read-Host`, manual ANSI escape sequences, or plain text menus with cleaner Spectre.Console wrappers.
- Creating a demo script that showcases module capabilities using `Get-SpectreDemoFeatures`, `Start-SpectreDemo`, `Get-SpectreDemoColors`, or related demo commands.
- Making PowerShell tooling feel more like a modern CLI/TUI without turning it into a full GUI.

Do not use this skill when the script must run silently in CI/CD, scheduled tasks, Intune remediation, ConfigMgr baselines, Azure Automation, or other non-interactive contexts unless you also build a non-interactive fallback path.

## Source of truth

Prefer the official docs and local module help over memory.

Primary references:

- Official docs: `https://pwshspectreconsole.com/`
- Demo feature reference: `https://pwshspectreconsole.com/reference/demo/get-spectredemofeatures/`
- GitHub repo: `https://github.com/ShaunLawrie/PwshSpectreConsole`
- Spectre.Console markup reference: `https://spectreconsole.net/markup`
- Spectre.Console emoji reference: `https://spectreconsole.net/appendix/emojis`

Useful local discovery commands:

```powershell
Get-Command -Module PwshSpectreConsole
Get-Help Start-SpectreDemo -Full
Get-Help Get-SpectreDemoFeatures -Full
Get-Help Read-SpectreSelection -Full
Get-Help Format-SpectreTable -Full
Get-Help Invoke-SpectreCommandWithProgress -Full
```

Use `Get-SpectreDemoFeatures` when you need to show or validate the range of Spectre.Console visual features available through the module. Use `Start-SpectreDemo` when the user wants an interactive walkthrough with examples.

## Baseline assumptions

PwshSpectreConsole is intended for PowerShell 7+.

Install with:

```powershell
Install-Module PwshSpectreConsole -Scope CurrentUser
```

For best rendering, assume the user should use a modern terminal, UTF-8 output encoding, and a font with broad glyph support, especially when using emoji, icons, or line drawing.

Recommended profile line:

```powershell
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
```

## Core design principles

Use PwshSpectreConsole to improve clarity, not to decorate every line.

Keep rich terminal UI purposeful:

- Use prompts for meaningful choices, not for values that can be inferred.
- Use tables for structured output, not for a single object.
- Use status spinners for short unknown-duration work.
- Use progress bars for known or measurable work.
- Use panels/rules/figlet text sparingly for sectioning and demos.
- Use markup only when it improves scanability.
- Escape dynamic user or external data before inserting it into Spectre markup.

Prefer readable, testable PowerShell over clever terminal effects.

## Standard implementation workflow

When adding PwshSpectreConsole to a script:

1. Identify whether the script is interactive or automation-oriented.
2. Add a guarded module import.
3. Create a small wrapper layer for output and prompts.
4. Keep business logic separate from UI rendering.
5. Add fallback behavior for non-interactive execution.
6. Use `-WhatIf`, `ShouldProcess`, or confirmation prompts for destructive actions.
7. Avoid breaking pipeline output unless the command is explicitly designed as an interactive command.
8. Test in Windows Terminal, VS Code integrated terminal, and a basic non-interactive shell if the script will be reused broadly.

## Recommended script scaffold

```powershell
#requires -Version 7.0

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$NonInteractive
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    Import-Module PwshSpectreConsole -ErrorAction Stop
}
catch {
    throw "PwshSpectreConsole is required. Install it with: Install-Module PwshSpectreConsole -Scope CurrentUser"
}

$script:IsInteractive = -not $NonInteractive -and [Environment]::UserInteractive

function Write-UiMessage {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('Info', 'Success', 'Warning', 'Error')]
        [string]$Level = 'Info'
    )

    if (-not $script:IsInteractive) {
        Write-Information $Message -InformationAction Continue
        return
    }

    $safeMessage = Get-SpectreEscapedText -Text $Message

    switch ($Level) {
        'Success' { Write-SpectreHost "[green]$safeMessage[/]" }
        'Warning' { Write-SpectreHost "[yellow]$safeMessage[/]" }
        'Error'   { Write-SpectreHost "[red]$safeMessage[/]" }
        default   { Write-SpectreHost "[grey]$safeMessage[/]" }
    }
}
```

## Prompt patterns

### Single selection

Use `Read-SpectreSelection` when the user must choose one item from a list.

```powershell
$choices = @('Audit only', 'Preview changes', 'Apply changes')

$mode = Read-SpectreSelection `
    -Message 'Choose an execution mode' `
    -Choices $choices `
    -Color 'Cyan1' `
    -EnableSearch

switch ($mode) {
    'Audit only'      { $Apply = $false; $Preview = $false }
    'Preview changes' { $Apply = $false; $Preview = $true }
    'Apply changes'   { $Apply = $true;  $Preview = $false }
}
```

For complex objects, use `-ChoiceLabelProperty` so the prompt displays a friendly label while returning the selected object.

```powershell
$selectedDevice = $devices | Read-SpectreSelection `
    -Message 'Select a device' `
    -ChoiceLabelProperty { "$($_.DeviceName) | $($_.OperatingSystem) | $($_.ComplianceState)" } `
    -EnableSearch
```

### Multi-selection

Use `Read-SpectreMultiSelection` when multiple items can be chosen.

```powershell
$selectedApps = $apps | Read-SpectreMultiSelection `
    -Message 'Select apps to include' `
    -ChoiceLabelProperty { "$($_.DisplayName) [$($_.Id)]" } `
    -PageSize 10
```

Use `-AllowEmpty` only when an empty selection is a valid outcome.

### Confirmation

Use `Read-SpectreConfirm` for destructive or expensive actions.

```powershell
$confirmed = Read-SpectreConfirm `
    -Message 'Continue with deleting stale assignments?' `
    -DefaultAnswer 'n' `
    -ConfirmSuccess '[green]Continuing...[/]' `
    -ConfirmFailure '[yellow]Cancelled.[/]'

if (-not $confirmed) {
    return
}
```

### Text input

Use `Read-SpectreText` for short validated strings. For sensitive values, use native secure input instead of rich text prompts unless the module explicitly supports the needed security behavior.

```powershell
$groupPrefix = Read-SpectreText -Message 'Enter the group prefix'

if ([string]::IsNullOrWhiteSpace($groupPrefix)) {
    throw 'Group prefix cannot be empty.'
}
```

## Output patterns

### Rich text output

Use `Write-SpectreHost` for human-facing messages with markup.

```powershell
Write-SpectreHost '[bold cyan]Intune Hydration Kit[/] [grey]starting...[/]'
Write-SpectreHost '[green]Completed successfully[/]'
Write-SpectreHost '[yellow]No matching devices found[/]'
Write-SpectreHost '[red]Failed to connect to Microsoft Graph[/]'
```

Never place raw user input, API data, file paths, or exception messages directly inside Spectre markup. Escape dynamic text first.

```powershell
$safeName = Get-SpectreEscapedText -Text $DeviceName
Write-SpectreHost "Processing [cyan]$safeName[/]"
```

### Tables

Use `Format-SpectreTable` for structured result sets.

```powershell
$devices |
    Select-Object DeviceName, OperatingSystem, ComplianceState, LastSyncDateTime |
    Format-SpectreTable `
        -Title 'Managed Devices' `
        -Border Rounded `
        -Color Cyan1 `
        -ShowRowSeparators
```

Use calculated properties when values need formatting or markup.

```powershell
$properties = @(
    @{ Name = 'Device';     Expression = { Get-SpectreEscapedText -Text $_.DeviceName } }
    @{ Name = 'OS';         Expression = { $_.OperatingSystem } }
    @{ Name = 'Compliance'; Expression = {
        switch ($_.ComplianceState) {
            'compliant'    { '[green]Compliant[/]' }
            'noncompliant' { '[red]Non-compliant[/]' }
            default        { '[yellow]Unknown[/]' }
        }
    }}
)

$devices | Format-SpectreTable -Property $properties -AllowMarkup -Title 'Compliance Summary'
```

Only use `-AllowMarkup` when you intentionally include Spectre markup in table cells.

### Rules and section headers

Use rules to split major phases.

```powershell
Write-SpectreRule -Title 'Discovery' -Color Cyan1
Write-SpectreRule -Title 'Remediation' -Color Yellow
Write-SpectreRule -Title 'Summary' -Color Green
```

### Panels

Use panels for summaries, warnings, and final status blocks.

```powershell
$summary = @"
Devices scanned: $ScannedCount
Issues found:    $IssueCount
Actions taken:   $ActionCount
"@

Format-SpectrePanel -Data $summary -Title 'Run Summary' -Color Cyan1
```

## Live feedback patterns

### Status spinner

Use `Invoke-SpectreCommandWithStatus` for unknown-duration tasks where a spinner is enough.

```powershell
$result = Invoke-SpectreCommandWithStatus `
    -Title 'Querying Microsoft Graph...' `
    -Spinner Dots2 `
    -Color Cyan1 `
    -ScriptBlock {
        Get-MgDeviceManagementManagedDevice -All
    }

Write-SpectreHost "Retrieved [green]$($result.Count)[/] devices."
```

Use `Write-SpectreHost` inside the status block for log messages that should not break the spinner.

### Progress bar

Use `Invoke-SpectreCommandWithProgress` when work can be measured.

```powershell
Invoke-SpectreCommandWithProgress -ScriptBlock {
    param(
        [Spectre.Console.ProgressContext]$Context
    )

    $task = $Context.AddTask('Processing devices')
    $total = [math]::Max($devices.Count, 1)

    foreach ($device in $devices) {
        # Do work here.
        Start-Sleep -Milliseconds 100

        $task.Increment(100 / $total)
    }

    if ($task.Percentage -lt 100) {
        $task.Value = 100
    }
}
```

Use an indeterminate task when the total amount of work is unknown.

```powershell
Invoke-SpectreCommandWithProgress -ScriptBlock {
    param([Spectre.Console.ProgressContext]$Context)

    $task = $Context.AddTask('Waiting for external operation')
    $task.IsIndeterminate = $true

    Invoke-SomeLongRunningOperation

    $task.Value = 100
}
```

## Demo and exploration commands

Use these commands when the task is to discover module features, create examples, or build training/demo content.

```powershell
Start-SpectreDemo
Get-SpectreDemoFeatures
Get-SpectreDemoColors
Get-SpectreDemoEmoji
Open-PwshSpectreConsoleHelp
```

`Get-SpectreDemoFeatures` is specifically useful when the user asks what Spectre.Console can visually do from PowerShell. Treat it as a feature showcase rather than a production dependency.

Recommended demo script structure:

```powershell
#requires -Version 7.0
Import-Module PwshSpectreConsole -ErrorAction Stop

Write-SpectreRule -Title 'PwshSpectreConsole Feature Demo' -Color Cyan1

Write-SpectreHost '[bold]Feature showcase[/]'
Get-SpectreDemoFeatures

Read-SpectrePause -Message 'Press enter to continue to the interactive demo.'
Start-SpectreDemo
```

## Error handling

Prefer normal PowerShell error handling. Use Spectre formatting only for human-readable display.

```powershell
try {
    Invoke-SomethingRisky
}
catch {
    if ($script:IsInteractive) {
        Format-SpectreException -Exception $_.Exception
    }
    else {
        Write-Error $_
    }
}
```

Do not hide exceptions behind pretty messages. Preserve enough detail for troubleshooting.

## Non-interactive fallback pattern

Do not force prompts in automation contexts. Add parameters so the same tool can run unattended.

```powershell
[CmdletBinding()]
param(
    [ValidateSet('Audit', 'Preview', 'Apply')]
    [string]$Mode,

    [switch]$NonInteractive
)

if (-not $Mode) {
    if ($NonInteractive -or -not [Environment]::UserInteractive) {
        $Mode = 'Audit'
    }
    else {
        $Mode = Read-SpectreSelection `
            -Message 'Choose mode' `
            -Choices @('Audit', 'Preview', 'Apply') `
            -EnableSearch
    }
}
```

For module functions, keep objects flowing through the pipeline. Put rich UI behind an explicit switch such as `-Interactive`, `-ShowUi`, or `-AsTable`.

## Testing checklist

Before considering the implementation complete:

- The script imports `PwshSpectreConsole` explicitly and fails clearly if missing.
- PowerShell 7+ is documented or enforced.
- Interactive prompts have non-interactive alternatives.
- Destructive choices require confirmation or support `ShouldProcess`.
- Dynamic text inserted into markup is escaped.
- Tables are used for structured output and do not destroy object output unless intended.
- Progress bars do not exceed 100 percent and handle zero-item collections.
- The script behaves acceptably in terminals without Nerd Font or full emoji support.
- The UX helps the user make decisions faster; it is not just decoration.

## Common mistakes to avoid

Avoid these patterns:

```powershell
# Bad: raw external text can break markup.
Write-SpectreHost "[green]$UserSuppliedText[/]"

# Bad: prompt blocks automation with no override.
$choice = Read-SpectreSelection -Choices $items -Message 'Choose one'

# Bad: table formatting too early destroys objects needed later.
$devices = Get-Devices | Format-SpectreTable

# Bad: every log line is high-contrast markup.
Write-SpectreHost '[bold red underline blink]Starting[/]'
```

Prefer these patterns:

```powershell
# Good: escape dynamic text.
$safeText = Get-SpectreEscapedText -Text $UserSuppliedText
Write-SpectreHost "[green]$safeText[/]"

# Good: parameterized fallback.
if (-not $PSBoundParameters.ContainsKey('Choice')) {
    $Choice = if ($NonInteractive) { 'Default' } else { Read-SpectreSelection -Choices $items -Message 'Choose one' }
}

# Good: keep data as data until display time.
$devices = Get-Devices
$devices | Format-SpectreTable -Title 'Devices'
```

## Review rubric

When reviewing generated code, check:

1. Does the terminal UI clarify the workflow?
2. Is business logic separated from presentation?
3. Can the script run without interaction?
4. Are prompts searchable when choice lists are long?
5. Are destructive actions protected?
6. Is dynamic Spectre markup escaped?
7. Are errors preserved, not hidden?
8. Are docs or local help consulted for command-specific syntax?

## Minimal example: interactive device cleanup shell

```powershell
#requires -Version 7.0
[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateSet('Audit', 'Preview', 'Apply')]
    [string]$Mode,

    [switch]$NonInteractive
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module PwshSpectreConsole -ErrorAction Stop

$isInteractive = -not $NonInteractive -and [Environment]::UserInteractive

if (-not $Mode) {
    $Mode = if ($isInteractive) {
        Read-SpectreSelection `
            -Message 'Choose cleanup mode' `
            -Choices @('Audit', 'Preview', 'Apply') `
            -EnableSearch `
            -Color Cyan1
    }
    else {
        'Audit'
    }
}

if ($isInteractive) {
    Write-SpectreRule -Title 'Discovery' -Color Cyan1
}

$devices = Invoke-SpectreCommandWithStatus `
    -Title 'Collecting stale devices...' `
    -Spinner Dots2 `
    -Color Cyan1 `
    -ScriptBlock {
        @(
            [pscustomobject]@{ DeviceName = 'LAPTOP-001'; LastSeenDays = 91; Action = 'Review' }
            [pscustomobject]@{ DeviceName = 'LAPTOP-002'; LastSeenDays = 144; Action = 'Remove' }
        )
    }

if ($isInteractive) {
    $devices | Format-SpectreTable -Title 'Stale Devices' -Border Rounded -Color Cyan1
}
else {
    $devices
}

if ($Mode -eq 'Apply') {
    $confirmed = if ($isInteractive) {
        Read-SpectreConfirm -Message 'Apply cleanup actions?' -DefaultAnswer n
    }
    else {
        $true
    }

    if ($confirmed -and $PSCmdlet.ShouldProcess('stale devices', 'Apply cleanup')) {
        Invoke-SpectreCommandWithProgress -ScriptBlock {
            param([Spectre.Console.ProgressContext]$Context)

            $task = $Context.AddTask('Applying cleanup')
            $total = [math]::Max($devices.Count, 1)

            foreach ($device in $devices) {
                Start-Sleep -Milliseconds 150
                $task.Increment(100 / $total)
            }

            $task.Value = 100
        }
    }
}
```

## Final instruction to the coding agent

When using this skill, produce PowerShell that is useful first and beautiful second. PwshSpectreConsole should make the script easier to understand, safer to operate, and more pleasant to use. Do not add terminal effects that obscure control flow, break automation, or make troubleshooting harder.
