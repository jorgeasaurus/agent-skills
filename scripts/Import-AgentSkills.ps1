#Requires -Version 5.1

<#
.SYNOPSIS
    Import installed Copilot agent skills into this repository.

.DESCRIPTION
    Finds agent skills by locating SKILL.md files under known agent tool
    configuration folders in your home directory, then copies each skill
    directory into this repository. Existing skill directories are skipped
    unless -Force is used.

.PARAMETER SourceRoot
    One or more directories to scan for installed skills. Defaults to
    installed skill locations under ~/.copilot, ~/.agents, ~/.codex, and
    ~/.claude.

.PARAMETER RepositoryRoot
    Repository directory to copy skills into. Defaults to this script's parent
    directory.

.PARAMETER Force
    Replace existing skill directories in the repository.

.PARAMETER PassThru
    Emit an object for each discovered skill.

.EXAMPLE
    ./scripts/Import-AgentSkills.ps1

    Copies installed skills from ~/.copilot/skills into this repository,
    skipping skills that already exist.

.EXAMPLE
    ./scripts/Import-AgentSkills.ps1 -Force -PassThru

    Replaces existing imported skills and returns import results.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$SourceRoot = @(
        (Join-Path -Path $HOME -ChildPath '.copilot/skills'),
        (Join-Path -Path $HOME -ChildPath '.agents/skills'),
        (Join-Path -Path $HOME -ChildPath '.codex/skills'),
        (Join-Path -Path $HOME -ChildPath '.claude/skills'),
        (Join-Path -Path $HOME -ChildPath '.claude/plugins-src/skills'),
        (Join-Path -Path $HOME -ChildPath '.claude/plugins/marketplaces')
    ),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$RepositoryRoot,

    [Parameter()]
    [switch]$Force,

    [Parameter()]
    [switch]$PassThru
)

begin {
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

    function Test-IsSubPath {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$Path,

            [Parameter(Mandatory)]
            [string]$ParentPath
        )

        $fullPath = Resolve-FullPath -Path $Path
        $fullParentPath = (Resolve-FullPath -Path $ParentPath).TrimEnd(
            [System.IO.Path]::DirectorySeparatorChar,
            [System.IO.Path]::AltDirectorySeparatorChar
        )

        return $fullPath.Equals($fullParentPath, [System.StringComparison]::OrdinalIgnoreCase) -or
            $fullPath.StartsWith(
                "$fullParentPath$([System.IO.Path]::DirectorySeparatorChar)",
                [System.StringComparison]::OrdinalIgnoreCase
            ) -or
            $fullPath.StartsWith(
                "$fullParentPath$([System.IO.Path]::AltDirectorySeparatorChar)",
                [System.StringComparison]::OrdinalIgnoreCase
            )
    }

    function Get-SkillName {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [System.IO.FileInfo]$Manifest
        )

        $name = Get-Content -LiteralPath $Manifest.FullName -TotalCount 80 |
            Where-Object { $_ -match '^name:\s*(.+?)\s*$' } |
            Select-Object -First 1 |
            ForEach-Object { $Matches[1].Trim(" `"'") }

        if ([string]::IsNullOrWhiteSpace($name)) {
            return $Manifest.Directory.Name
        }

        return $name
    }

    function ConvertTo-SafeDirectoryName {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$Name,

            [Parameter(Mandatory)]
            [string]$FallbackName
        )

        $safeName = $Name.Trim() -replace '\s+', '-' -replace '[^A-Za-z0-9._-]', '-'

        if ([string]::IsNullOrWhiteSpace($safeName)) {
            return $FallbackName
        }

        return $safeName
    }

    if (-not $RepositoryRoot) {
        if ($PSScriptRoot) {
            $RepositoryRoot = Split-Path -Parent $PSScriptRoot
        }
        else {
            $RepositoryRoot = (Get-Location).Path
        }
    }

    $resolvedSourceRoots = foreach ($root in $SourceRoot) {
        if (-not (Test-Path -LiteralPath $root -PathType Container)) {
            Write-Warning "Skipping SourceRoot because it does not exist or is not a directory: $root"
            continue
        }

        Resolve-FullPath -Path $root
    }

    if (-not (Test-Path -LiteralPath $RepositoryRoot -PathType Container)) {
        throw "RepositoryRoot does not exist or is not a directory: $RepositoryRoot"
    }

    if (-not $resolvedSourceRoots) {
        throw 'No valid SourceRoot directories were found.'
    }

    $resolvedRepositoryRoot = Resolve-FullPath -Path $RepositoryRoot
    $seenSkillNames = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase
    )
}

process {
    $manifestEntries = @(
        for ($index = 0; $index -lt $resolvedSourceRoots.Count; $index++) {
            Get-ChildItem -LiteralPath $resolvedSourceRoots[$index] -Filter 'SKILL.md' -File -Recurse -Force |
                Where-Object { -not (Test-IsSubPath -Path $_.Directory.FullName -ParentPath $resolvedRepositoryRoot) } |
                ForEach-Object {
                    [pscustomobject]@{
                        SourceIndex = $index
                        Manifest    = $_
                    }
                }
        }
    ) |
        Sort-Object -Property SourceIndex, @{ Expression = { $_.Manifest.FullName } }

    foreach ($entry in $manifestEntries) {
        $manifest = $entry.Manifest
        $sourceDirectory = $manifest.Directory.FullName
        $skillName = Get-SkillName -Manifest $manifest
        $destinationName = ConvertTo-SafeDirectoryName -Name $skillName -FallbackName $manifest.Directory.Name
        $destinationDirectory = Join-Path -Path $resolvedRepositoryRoot -ChildPath $destinationName

        if (-not $seenSkillNames.Add($destinationName)) {
            Write-Verbose "Skipping duplicate skill name '$destinationName' from $sourceDirectory."
            continue
        }

        if ((Test-Path -LiteralPath $destinationDirectory) -and -not $Force) {
            $result = [pscustomobject]@{
                Name        = $destinationName
                Source      = $sourceDirectory
                Destination = $destinationDirectory
                Action      = 'Skipped'
                Reason      = 'Destination exists. Use -Force to replace it.'
            }

            Write-Verbose $result.Reason
            if ($PassThru) {
                $result
            }

            continue
        }

        if ($PSCmdlet.ShouldProcess($destinationDirectory, "Import skill '$destinationName'")) {
            if (Test-Path -LiteralPath $destinationDirectory) {
                Remove-Item -LiteralPath $destinationDirectory -Recurse -Force
            }

            Copy-Item -LiteralPath $sourceDirectory -Destination $destinationDirectory -Recurse -Force

            $result = [pscustomObject]@{
                Name        = $destinationName
                Source      = $sourceDirectory
                Destination = $destinationDirectory
                Action      = 'Copied'
                Reason      = $null
            }

            Write-Host "Imported skill: $destinationName"
            if ($PassThru) {
                $result
            }
        }
    }
}
