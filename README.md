# Agent Skills

A collection of reusable [Copilot agent skills](https://docs.github.com/en/copilot/customizing-copilot/copilot-extensions/building-copilot-skillsets) for PowerShell development workflows. These skills extend GitHub Copilot with deep domain knowledge for writing scripts, building modules, and scaffolding production-ready projects.

## Skills

### [powershell-expert](powershell-expert/)

Expert-level guidance for PowerShell script development, GUI creation, and module discovery.

- **Script development** — Verb-Noun naming, strong typing, validation attributes, pipeline support, `ShouldProcess` for destructive operations
- **Error handling** — Structured `try/catch` with typed exceptions, `ErrorAction` best practices
- **GUI development** — Windows Forms for simple dialogs, WPF/XAML for complex interfaces
- **PowerShell Gallery** — Search, install, and verify modules via PSResourceGet with live validation against the gallery
- **Live verification** — Checks module availability and cmdlet syntax against Microsoft Docs and the PowerShell Gallery before recommending them

### [powershell-module-scaffold](powershell-module-scaffold/)

Full project scaffolding for production-ready PowerShell modules — from a single module name to a publishable project.

- **Project structure** — `Public/`, `Private/`, `Tests/`, manifest, module loader, build script
- **CI/CD** — GitHub Actions workflow with multi-OS matrix (Ubuntu, Windows, macOS), automated PSGallery publishing on version tags
- **Testing** — Pester 5 test skeleton with module import validation, parameter inspection patterns, and mocking guidance
- **Code quality** — PSScriptAnalyzer settings, `Format-AllFiles.ps1` formatter (OTBS style)
- **VS Code integration** — Workspace file, editor settings, and task definitions for build/test/analyze/format
- **GitHub community files** — Issue templates, PR template, security policy, funding config, and Copilot instructions

### [powershell-code-review](powershell-code-review/)

Production-readiness code review for PowerShell scripts and modules, applying Elon Musk's 5-Step Design Process.

- **5-Step review process** — Question requirements, delete ruthlessly, simplify, accelerate, automate — in that order
- **Code elimination** — Identifies functions, parameters, abstractions, and logic blocks that should not exist
- **Security audit** — Credentials, tokens, injection risks, least privilege, destructive operation guards
- **Performance analysis** — N+1 patterns, unnecessary materialization, pipeline blocking, redundant API calls
- **Structured report** — Outputs a markdown report with Critical Issues, Recommended Deletions, Enhancements, and Risk Assessment
- **No politeness tax** — Direct criticism with quantified cost and forced author justification for every finding

## Usage

Add a skill to your Copilot configuration by referencing it from this repository:

```json
{
  "skills": [
    {
      "name": "powershell-expert",
      "source": "github:jorgeasaurus/agent-skills/powershell-expert"
    },
    {
      "name": "powershell-module-scaffold",
      "source": "github:jorgeasaurus/agent-skills/powershell-module-scaffold"
    },
    {
      "name": "powershell-code-review",
      "source": "github:jorgeasaurus/agent-skills/powershell-code-review"
    }
  ]
}
```

Each skill directory contains a `SKILL.md` that defines the skill's name, description, and instructions, along with a `references/` folder with supporting documentation and templates.

## License

MIT
