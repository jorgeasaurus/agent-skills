#Requires -Version 5.1

<#!
.SYNOPSIS
    Install repository skills into global agent skill folders.

.DESCRIPTION
    Scans the repository root for top-level skill directories containing either
    SKILL.md or skill.md, then copies each skill into the selected user-level
    runtime folders under the current home directory. Runtime installs are only
    applied when the runtime's hidden home folder already exists. Existing
    installed skill directories are replaced.

.PARAMETER RepositoryRoot
    Repository directory to scan. Defaults to the repository containing this
    script.

.PARAMETER Target
    One or more runtimes to install for. Defaults to Agents, Codex, Claude,
    and Copilot.

.PARAMETER PassThru
    Emit an object for each installed skill.

.EXAMPLE
    ./scripts/Install-AgentSkills.ps1

    Installs all repository skills into ~/.agents/skills, ~/.codex/skills,
    ~/.claude/skills, and ~/.copilot/skills when those runtime home folders
    already exist, replacing existing copies.

.EXAMPLE
    ./scripts/Install-AgentSkills.ps1 -Target Agents,Codex,Claude -WhatIf

    Shows what would be installed for Agents, Codex, and Claude without
    changing files.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$RepositoryRoot,

    [Parameter()]
    [ValidateSet('Agents', 'Codex', 'Claude', 'Copilot')]
    [string[]]$Target = @('Agents', 'Codex', 'Claude', 'Copilot'),

    [Parameter()]
    [switch]$PassThru
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-FullPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    [System.IO.Path]::GetFullPath($Path)
}

function Get-ManifestPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DirectoryPath
    )

    foreach ($candidate in @('SKILL.md', 'skill.md')) {
        $manifestPath = Join-Path -Path $DirectoryPath -ChildPath $candidate
        if (Test-Path -LiteralPath $manifestPath -PathType Leaf) {
            return $manifestPath
        }
    }

    return $null
}

function Get-RuntimePaths {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Agents', 'Codex', 'Claude', 'Copilot')]
        [string]$Runtime
    )

    switch ($Runtime) {
        'Agents' {
            return [pscustomobject]@{
                Home  = Join-Path -Path $HOME -ChildPath '.agents'
                Skills = Join-Path -Path $HOME -ChildPath '.agents/skills'
            }
        }

        'Codex' {
            return [pscustomobject]@{
                Home  = Join-Path -Path $HOME -ChildPath '.codex'
                Skills = Join-Path -Path $HOME -ChildPath '.codex/skills'
            }
        }

        'Claude' {
            return [pscustomobject]@{
                Home  = Join-Path -Path $HOME -ChildPath '.claude'
                Skills = Join-Path -Path $HOME -ChildPath '.claude/skills'
            }
        }

        'Copilot' {
            return [pscustomobject]@{
                Home  = Join-Path -Path $HOME -ChildPath '.copilot'
                Skills = Join-Path -Path $HOME -ChildPath '.copilot/skills'
            }
        }
    }
}

function Copy-SkillDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath,

        [Parameter(Mandatory)]
        [string]$DestinationPath
    )

    $null = New-Item -ItemType Directory -Path $DestinationPath -Force

    Get-ChildItem -LiteralPath $SourcePath -Force |
        Where-Object { $_.Name -ne 'scripts' } |
        ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination $DestinationPath -Recurse -Force
        }
}

if ($RepositoryRoot) {
    if (-not (Test-Path -LiteralPath $RepositoryRoot -PathType Container)) {
        throw "RepositoryRoot does not exist or is not a directory: $RepositoryRoot"
    }
}
elseif ($PSScriptRoot) {
    $RepositoryRoot = Split-Path -Parent $PSScriptRoot
}
else {
    $RepositoryRoot = (Get-Location).Path
}

$resolvedRepositoryRoot = Resolve-FullPath -Path $RepositoryRoot

$skillDirectories = @(
    Get-ChildItem -LiteralPath $resolvedRepositoryRoot -Directory -Force |
        Where-Object {
            $null -ne (Get-ManifestPath -DirectoryPath $_.FullName)
        }
        Sort-Object -Property Name
)

if (-not $skillDirectories) {
    throw "No top-level skills were found in repository root: $resolvedRepositoryRoot"
}

foreach ($runtime in $Target) {
    $runtimePaths = Get-RuntimePaths -Runtime $runtime

    if (-not (Test-Path -LiteralPath $runtimePaths.Home -PathType Container)) {
        Write-Warning "Skipping $runtime because runtime home folder does not exist: $($runtimePaths.Home)"
        continue
    }

    if (-not (Test-Path -LiteralPath $runtimePaths.Skills -PathType Container)) {
        if ($PSCmdlet.ShouldProcess($runtimePaths.Skills, "Create $runtime skills directory")) {
            $null = New-Item -ItemType Directory -Path $runtimePaths.Skills -Force
        }
    }

    foreach ($skillDirectory in $skillDirectories) {
        $destinationPath = Join-Path -Path $runtimePaths.Skills -ChildPath $skillDirectory.Name

        if ($PSCmdlet.ShouldProcess($destinationPath, "Install skill '$($skillDirectory.Name)' for $runtime")) {
            if (Test-Path -LiteralPath $destinationPath) {
                Remove-Item -LiteralPath $destinationPath -Recurse -Force
            }

            Copy-SkillDirectory -SourcePath $skillDirectory.FullName -DestinationPath $destinationPath

            $result = [pscustomobject]@{
                Runtime     = $runtime
                Skill       = $skillDirectory.Name
                Source      = $skillDirectory.FullName
                Destination = $destinationPath
                Action      = 'Installed'
                Repository  = $resolvedRepositoryRoot
            }

            Write-Host "Installed $($skillDirectory.Name) for $runtime"
            if ($PassThru) {
                $result
            }
        }
    }
}