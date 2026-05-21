# Agent Skills

A collection of reusable agent skills for development workflows. Each skill lives in its own directory and provides domain-specific instructions, references, and supporting scripts for Copilot, Codex, Claude, and other agent runtimes.

## Quick Start

Install everything in one shot without cloning the repo first:

```powershell
irm https://raw.githubusercontent.com/jorgeasaurus/agent-skills/main/scripts/Install-AgentSkills-Bootstrap.ps1 | iex
```

That one-liner bootstraps or refreshes a cached clone under `~/.agent-skills/agent-skills`, then installs the skills into any supported runtime home folders that already exist.

## Skills

| Skill | Purpose |
| --- | --- |
| [Browser-Automation](Browser-Automation/) | Browser automation through natural-language CLI commands. |
| [agent-browser](agent-browser/) | Browser interaction, web testing, screenshots, and page data extraction. |
| [agent-development](agent-development/) | Claude Code subagent structure, prompts, tools, and trigger guidance. |
| [agent-dx-cli-scale](agent-dx-cli-scale/) | Evaluation scale for CLI design quality for AI agents. |
| [claude-automation-recommender](claude-automation-recommender/) | Recommends Claude Code automations for a repository. |
| [claude-md-improver](claude-md-improver/) | Audits and improves `CLAUDE.md` project memory files. |
| [code-simplifier](code-simplifier/) | Refactors code for clarity while preserving behavior. |
| [command-development](command-development/) | Claude Code slash command design and implementation guidance. |
| [diagnose](diagnose/) | Disciplined bug and performance regression diagnosis loop. |
| [do-plan](do-plan/) | Executes phased implementation plans with subagents. |
| [drawio-skill](drawio-skill/) | Creates diagrams, flowcharts, and architecture visuals. |
| [example-skill](example-skill/) | Reference template for skill development patterns. |
| [find-skills](find-skills/) | Discovers and installs useful agent skills. |
| [frontend-design](frontend-design/) | Produces polished frontend interfaces and UI implementations. |
| [grill-me](grill-me/) | Stress-tests a plan or design through focused questioning. |
| [grill-with-docs](grill-with-docs/) | Challenges plans against project domain docs and ADRs. |
| [handoff](handoff/) | Writes handoff documentation for follow-on agents. |
| [hook-development](hook-development/) | Claude Code hook creation and event automation guidance. |
| [imagegen](imagegen/) | Generates or edits raster images for agent workflows. |
| [improve-codebase-architecture](improve-codebase-architecture/) | Finds architecture, testability, and maintainability improvements. |
| [ink](ink/) | Builds terminal UIs with Ink and JSON render specs. |
| [karpathy-guidelines](karpathy-guidelines/) | Behavioral guidelines for safer, simpler LLM coding. |
| [make-plan](make-plan/) | Creates phased implementation plans with documentation discovery. |
| [mcp-integration](mcp-integration/) | Integrates MCP servers into Claude Code plugins. |
| [mem-search](mem-search/) | Searches persistent cross-session Claude memory. |
| [msgraph](msgraph/) | Local Microsoft Graph API endpoint and schema knowledge. |
| [onboard-computer](onboard-computer/) | Generates `.onboard` files and dependency scans. |
| [openai-docs](openai-docs/) | Uses official OpenAI documentation for API and product guidance. |
| [openclaw](openclaw/) | OpenClaw planning and agent workflow support. |
| [playground](playground/) | Creates interactive single-file HTML playgrounds. |
| [playwright-testing](playwright-testing/) | End-to-end testing with Playwright. |
| [plugin-creator](plugin-creator/) | Scaffolds Codex plugin directories and manifests. |
| [plugin-settings](plugin-settings/) | Documents plugin configuration and local settings patterns. |
| [plugin-structure](plugin-structure/) | Claude Code plugin layout, manifest, and organization guidance. |
| [powershell-code-review](powershell-code-review/) | Production-readiness review for PowerShell scripts and modules. |
| [powershell-expert](powershell-expert/) | PowerShell scripting, modules, GUI, and gallery guidance. |
| [powershell-module-scaffold](powershell-module-scaffold/) | Scaffolds production-ready PowerShell modules. |
| [pptx](pptx/) | Reads, creates, and modifies PowerPoint presentations. |
| [react-components](react-components/) | Converts designs into modular Vite and React components. |
| [remotion-best-practices](remotion-best-practices/) | Best practices for Remotion video creation in React. |
| [setup-matt-pocock-skills](setup-matt-pocock-skills/) | Configures project context for Matt Pocock-style engineering skills. |
| [skill-creator](skill-creator/) | Creates, improves, evaluates, and benchmarks skills. |
| [skill-development](skill-development/) | Skill structure, progressive disclosure, and development guidance. |
| [skill-installer](skill-installer/) | Installs Codex skills from curated lists or GitHub repositories. |
| [stripe-best-practices](stripe-best-practices/) | Stripe checkout, subscriptions, webhooks, and API integration guidance. |
| [tdd](tdd/) | Test-driven development using red-green-refactor. |
| [tdd-red-green-refactor](tdd-red-green-refactor/) | Disciplined TypeScript/Node.js TDD workflow. |
| [typed-service-contracts](typed-service-contracts/) | Type-safe TypeScript service contracts with spec and handler patterns. |
| [web-design-guidelines](web-design-guidelines/) | Reviews web UI code for design and accessibility quality. |
| [writing-hookify-rules](writing-hookify-rules/) | Creates Hookify rules and explains rule syntax. |
| [zoom-out](zoom-out/) | Provides broader architectural context and higher-level perspective. |

## Import installed skills

Use the PowerShell importer to copy installed skills from your home directory into this repository:

```powershell
./scripts/Import-AgentSkills.ps1
```

The importer scans these installed skill locations by default:

```text
~/.copilot/skills
~/.agents/skills
~/.codex/skills
~/.claude/skills
~/.claude/plugins-src/skills
~/.claude/plugins/marketplaces
```

Existing skill directories are skipped unless you pass `-Force`:

```powershell
./scripts/Import-AgentSkills.ps1 -Force -PassThru
```

Use `-WhatIf` to preview what would be imported:

```powershell
./scripts/Import-AgentSkills.ps1 -WhatIf -PassThru
```

## Install repository skills

Use the PowerShell installer to copy every top-level repository skill into your
existing `.agents`, Codex, Claude, and Copilot skill folders:

```powershell
./scripts/Install-AgentSkills.ps1
```

The installer checks these runtime homes by default. If the hidden runtime home
folder exists, it installs into that runtime's `skills` folder and replaces any
existing skill directory with the same name:

```text
~/.agents/skills
~/.codex/skills
~/.claude/skills
~/.copilot/skills
```

Use `-WhatIf` to preview the install, or `-Target` to limit which runtimes are
updated:

```powershell
./scripts/Install-AgentSkills.ps1 -WhatIf -PassThru
./scripts/Install-AgentSkills.ps1 -Target Agents,Codex,Claude
```

## Usage

Reference a skill from this repository in an agent configuration:

```json
{
  "skills": [
    {
      "name": "powershell-expert",
      "source": "github:jorgeasaurus/agent-skills/powershell-expert"
    }
  ]
}
```

Each skill directory contains a `SKILL.md` or `skill.md` manifest that defines the skill name, description, and instructions. Some skills also include `references/`, `scripts/`, or other supporting files.

## License

MIT
