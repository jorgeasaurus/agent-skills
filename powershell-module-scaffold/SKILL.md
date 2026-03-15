---
name: powershell-module-scaffold
description: Scaffold production-ready PowerShell modules with CI/CD, VS Code integration, Pester tests, and PSScriptAnalyzer. Use when creating a new PowerShell module from scratch or adding build/test/CI infrastructure to an existing module. Generates project structure, build scripts, GitHub Actions workflows, VS Code tasks, and formatting tools.
---

# PowerShell Module Scaffold

Generate a complete, production-ready PowerShell module project with CI/CD, testing, analysis, and editor integration — all from a module name.

## When to Use This Skill

- Creating a new PowerShell module from scratch
- Adding build/test/CI infrastructure to an existing module
- Setting up VS Code workspace for a PowerShell project
- Generating GitHub Actions CI/CD for a PowerShell Gallery module

## Project Structure

When scaffolding a new module named `{ModuleName}`, generate this structure:

```
{ModuleName}/
├── .github/
│   ├── FUNDING.yml
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug-report.md
│   │   └── feature_request.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── SECURITY.md
│   ├── instructions/
│   │   ├── powershell.instructions.md
│   │   └── powershell-pester-5.instructions.md
│   └── workflows/
│       ├── WORKFLOW-TRIGGERS.md
│       └── ci.yml
├── .vscode/
│   ├── settings.json
│   └── tasks.json
├── Private/              # Internal functions (not exported)
├── Public/               # Exported functions
├── Tests/
│   └── {ModuleName}.Tests.ps1
├── scripts/
│   └── Format-AllFiles.ps1
├── build/                # Build output (gitignored)
├── {ModuleName}.code-workspace
├── {ModuleName}.psd1     # Module manifest
├── {ModuleName}.psm1     # Module loader
├── build.ps1             # Build script
├── PSScriptAnalyzerSettings.psd1
└── README.md
```

## Core Templates

### Module Manifest — `{ModuleName}.psd1`

```powershell
@{
    RootModule        = '{ModuleName}.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '{GENERATE-NEW-GUID}'
    Author            = '{AuthorName}'
    CompanyName       = 'Unknown'
    Copyright         = '(c) {Year}. All rights reserved.'
    Description       = '{ModuleDescription}'

    PowerShellVersion = '5.1'

    FunctionsToExport = @(
        # Add exported function names here
    )
    CmdletsToExport   = @()
    VariablesToExport  = @()
    AliasesToExport    = @()

    PrivateData = @{
        PSData = @{
            Tags       = @()
            ProjectUri = ''
            ReleaseNotes = ''
        }
    }
}
```

Generate a real GUID with `[guid]::NewGuid().ToString()` — never use a placeholder.

### Module Loader — `{ModuleName}.psm1`

```powershell
$Private = @(Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1" -ErrorAction SilentlyContinue)
$Public  = @(Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1"  -ErrorAction SilentlyContinue)

foreach ($file in @($Private + $Public)) {
    try {
        . $file.FullName
    } catch {
        Write-Error "Failed to import $($file.FullName): $_"
    }
}
```

### Build Script — `build.ps1`

```powershell
<#
.SYNOPSIS
    Build script for {ModuleName}. Bootstraps dependencies and runs build tasks.
.PARAMETER Task
    The task to execute. If omitted, installs build dependencies (bootstrap).
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('Analyze', 'Test', 'Build', 'CI', 'Clean')]
    [string]$Task
)

$ErrorActionPreference = 'Stop'

$moduleName = '{ModuleName}'
$buildDir = Join-Path $PSScriptRoot 'build' $moduleName
$sourceFiles = @(
    '{ModuleName}.psd1'
    '{ModuleName}.psm1'
    'Public'
    'Private'
)

function Install-BuildDependency {
    $modules = @(
        @{ Name = 'Pester';            MinimumVersion = '5.0.0' }
        @{ Name = 'PSScriptAnalyzer';  MinimumVersion = '1.21.0' }
    )

    foreach ($mod in $modules) {
        $installed = Get-Module -ListAvailable -Name $mod.Name |
            Where-Object { $_.Version -ge [version]$mod.MinimumVersion } |
            Sort-Object Version -Descending |
            Select-Object -First 1

        if ($installed) {
            Write-Host "  [OK] $($mod.Name) $($installed.Version)" -ForegroundColor Green
        } else {
            Write-Host "  Installing $($mod.Name) >= $($mod.MinimumVersion)..." -ForegroundColor Yellow
            Install-Module -Name $mod.Name -MinimumVersion $mod.MinimumVersion -Scope CurrentUser -Force -SkipPublisherCheck
            Write-Host "  [OK] $($mod.Name) installed" -ForegroundColor Green
        }
    }
}

function Invoke-Analyze {
    Write-Host "`n=== PSScriptAnalyzer ===" -ForegroundColor Cyan
    $results = Invoke-ScriptAnalyzer -Path $PSScriptRoot -Recurse -Settings (Join-Path $PSScriptRoot 'PSScriptAnalyzerSettings.psd1')

    if ($results) {
        $results | Format-Table -AutoSize
        throw "PSScriptAnalyzer found $($results.Count) issue(s)."
    }

    Write-Host "  No issues found." -ForegroundColor Green
}

function Invoke-Test {
    Write-Host "`n=== Pester Tests ===" -ForegroundColor Cyan
    $config = New-PesterConfiguration
    $config.Run.Path = Join-Path $PSScriptRoot 'Tests'
    $config.Output.Verbosity = 'Detailed'
    $config.Run.Exit = $true

    Invoke-Pester -Configuration $config
}

function Invoke-Build {
    Write-Host "`n=== Build Module ===" -ForegroundColor Cyan

    if (Test-Path $buildDir) {
        Remove-Item $buildDir -Recurse -Force
    }
    New-Item -Path $buildDir -ItemType Directory -Force | Out-Null

    foreach ($item in $sourceFiles) {
        $source = Join-Path $PSScriptRoot $item
        if (Test-Path $source) {
            $dest = Join-Path $buildDir $item
            if ((Get-Item $source).PSIsContainer) {
                Copy-Item -Path $source -Destination $dest -Recurse -Force
            } else {
                Copy-Item -Path $source -Destination $dest -Force
            }
        }
    }

    Write-Host "  Module staged to: $buildDir" -ForegroundColor Green
    Test-ModuleManifest -Path (Join-Path $buildDir "$moduleName.psd1") | Format-List Name, Version, Description
}

function Invoke-Clean {
    Write-Host "`n=== Clean ===" -ForegroundColor Cyan
    $buildRoot = Join-Path $PSScriptRoot 'build'
    if (Test-Path $buildRoot) {
        Remove-Item $buildRoot -Recurse -Force
        Write-Host "  Removed $buildRoot" -ForegroundColor Green
    } else {
        Write-Host "  Nothing to clean." -ForegroundColor DarkGray
    }
}

# ── Main ──

Write-Host "{ModuleName} Build Script" -ForegroundColor Cyan
Write-Host "Task: $(if ($Task) { $Task } else { 'Bootstrap' })`n"

Write-Host "=== Dependencies ===" -ForegroundColor Cyan
Install-BuildDependency

if (-not $Task) {
    Write-Host "`nBootstrap complete." -ForegroundColor Green
    return
}

switch ($Task) {
    'Analyze' { Invoke-Analyze }
    'Test'    { Invoke-Test }
    'Build'   { Invoke-Build }
    'Clean'   { Invoke-Clean }
    'CI' {
        Invoke-Analyze
        Invoke-Test
        Invoke-Build
    }
}

Write-Host "`nTask '$Task' completed." -ForegroundColor Green
```

### PSScriptAnalyzer Settings — `PSScriptAnalyzerSettings.psd1`

```powershell
@{
    Severity = @('Error', 'Warning')

    ExcludeRules = @(
        'PSAvoidUsingPositionalParameters'
        'PSUseDeclaredVarsMoreThanAssignments'
        'PSUseSingularNouns'
        'PSAvoidUsingWriteHost'
        'PSAvoidUsingBrokenHashAlgorithms'
        'PSUseBOMForUnicodeEncodedFile'
    )
}
```

Adjust ExcludeRules per project. Only exclude rules with a documented reason.

### Format Script — `scripts/Format-AllFiles.ps1`

```powershell
<#
.SYNOPSIS
    Formats all PowerShell files in the repository using PSScriptAnalyzer.
.DESCRIPTION
    Uses Invoke-Formatter with OTBS (One True Brace Style) settings to format
    all .ps1 and .psm1 files, excluding the build directory.
#>
[CmdletBinding()]
param()

$files = Get-ChildItem -Path $PSScriptRoot/.. -Include *.ps1, *.psm1 -Recurse -File |
    Where-Object { $_.DirectoryName -notlike '*build*' }

Write-Host "Formatting $($files.Count) PowerShell files..." -ForegroundColor Cyan

foreach ($file in $files) {
    try {
        $content = Get-Content $file.FullName -Raw
        $formatted = Invoke-Formatter -ScriptDefinition $content -Settings CodeFormattingOTBS
        Set-Content -Path $file.FullName -Value $formatted -NoNewline
        Write-Host "  Formatted: $($file.Name)" -ForegroundColor Green
    } catch {
        Write-Host "  Failed: $($file.Name) - $_" -ForegroundColor Red
    }
}

Write-Host "Done!" -ForegroundColor Cyan
```

### Pester Test Skeleton — `Tests/{ModuleName}.Tests.ps1`

```powershell
#Requires -Modules Pester

BeforeAll {
    $ModulePath = Join-Path $PSScriptRoot '..' '{ModuleName}.psd1'
    Import-Module $ModulePath -Force
}

Describe '{ModuleName} Module' {
    Context 'Module loads correctly' {
        It 'Should import without errors' {
            { Import-Module (Join-Path $PSScriptRoot '..' '{ModuleName}.psd1') -Force } | Should -Not -Throw
        }

        It 'Should export expected functions' {
            $exported = (Get-Module {ModuleName}).ExportedFunctions.Keys
            $exported | Should -Not -BeNullOrEmpty
        }
    }
}

# Add per-function Describe blocks:
# Describe 'FunctionName' {
#     Context 'When condition' {
#         It 'Should expected behavior' {
#             # Arrange, Act, Assert
#         }
#     }
# }
```

**Testing rules:**
- Never invoke a command without required parameters to test that they're mandatory. Instead, inspect the parameter attribute:
  ```powershell
  It 'Should require -Name parameter' {
      $param = (Get-Command Get-Something).Parameters['Name']
      $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })
      $attr[0].Mandatory | Should -BeTrue
  }
  ```
- Use `Mock` for external dependencies.
- Dot-source private functions directly for unit testing.

## VS Code Configuration

### `.vscode/settings.json`

```json
{
    "[powershell]": {
        "editor.defaultFormatter": "ms-vscode.powershell",
        "editor.formatOnSave": false,
        "editor.tabSize": 4,
        "editor.insertSpaces": true
    },
    "[json]": {
        "editor.defaultFormatter": "vscode.json-language-features",
        "editor.formatOnSave": false,
        "editor.tabSize": 4
    },
    "powershell.codeFormatting.preset": "OTBS",
    "powershell.codeFormatting.openBraceOnSameLine": true,
    "powershell.codeFormatting.newLineAfterOpenBrace": true,
    "powershell.codeFormatting.whitespaceBeforeOpenBrace": true,
    "powershell.codeFormatting.whitespaceBeforeOpenParen": true,
    "powershell.codeFormatting.whitespaceAroundOperator": true,
    "powershell.codeFormatting.whitespaceAfterSeparator": true,
    "powershell.codeFormatting.ignoreOneLineBlock": true,
    "powershell.codeFormatting.alignPropertyValuePairs": true,
    "powershell.codeFormatting.useCorrectCasing": true
}
```

### `.vscode/tasks.json`

Replace `{ModuleName}` in all task definitions. Include these tasks:

| Label | Args | Group |
|-------|------|-------|
| Bootstrap: Install Dependencies | `build.ps1` | build |
| Build: Analyze (PSScriptAnalyzer) | `build.ps1 -Task Analyze` | build |
| Build: Test (Pester) | `build.ps1 -Task Test` | test |
| Build: Build Module | `build.ps1 -Task Build` | build (default) |
| Build: Full CI (Analyze + Test + Build) | `build.ps1 -Task CI` | build |
| Build: Clean | `build.ps1 -Task Clean` | build |
| Module: Import Local | `-Command Import-Module ./{ModuleName}.psd1 -Force -Verbose` | none |
| Module: Get ReleaseNotes | `-Command (Import-PowerShellDataFile ./{ModuleName}.psd1).PrivateData.PSData.ReleaseNotes` | none |
| Module: Get Version | `-Command (Import-PowerShellDataFile ./{ModuleName}.psd1).ModuleVersion` | none |
| Format: All PowerShell Files | `scripts/Format-AllFiles.ps1` | none |

All tasks use `pwsh -NoProfile`. See `references/tasks-template.json` for the full JSON.

### `{ModuleName}.code-workspace`

```json
{
    "folders": [{ "path": "." }],
    "settings": {
        "terminal.integrated.defaultProfile.windows": "PowerShell",
        "terminal.integrated.profiles.windows": {
            "PowerShell": {
                "source": "PowerShell",
                "icon": "terminal-powershell"
            }
        },
        "powershell.powerShellDefaultVersion": "PowerShell (x64)",
        "files.associations": {
            "*.ps1": "powershell",
            "*.psm1": "powershell",
            "*.psd1": "powershell"
        }
    }
}
```

## GitHub Configuration

### CI/CD — `.github/workflows/ci.yml`

The workflow has two jobs:

**build** — Runs on a matrix of `ubuntu-latest`, `windows-latest`, `macos-latest`:
1. Checkout → Bootstrap → PSScriptAnalyzer → Pester → Build Module
2. Uploads test results per OS, build artifacts from Windows only

**release** — Triggered on `v*.*.*` tags, Windows only:
1. Downloads artifacts → Validates tag matches manifest version
2. Publishes to PowerShell Gallery → Creates GitHub Release with archive

See `references/ci-template.yml` for the full workflow. Replace `{ModuleName}` throughout.

**Required secrets:** `PSGALLERY_API_KEY`

### Community Files

Generate these files with `{ModuleName}` and `{AuthorGitHub}` substituted:

- **FUNDING.yml** — `github: {AuthorGitHub}`
- **SECURITY.md** — Vulnerability reporting via GitHub Security Advisories
- **PULL_REQUEST_TEMPLATE.md** — Type of change checklist, description, review checklist
- **ISSUE_TEMPLATE/bug-report.md** — Expected/actual behavior, reproduction steps, environment
- **ISSUE_TEMPLATE/feature_request.md** — Description, proposed solution, alternatives

### Copilot Instructions

Copy the `powershell.instructions.md` and `powershell-pester-5.instructions.md` from `references/` into `.github/instructions/`. These provide coding guidelines to Copilot when working in the project.

## Scaffolding Checklist

When creating a new module:

1. Create directory structure (Public/, Private/, Tests/, scripts/, .vscode/, .github/)
2. Generate a real GUID for the manifest
3. Create all template files with `{ModuleName}` replaced
4. Run `./build.ps1` to bootstrap dependencies
5. Run `./build.ps1 -Task CI` to verify everything passes
6. Initialize git repo and make initial commit
