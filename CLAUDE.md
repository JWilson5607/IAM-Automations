# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Teaching and demonstration repo for PowerShell scripting concepts. Scripts here are intentionally instructional — they illustrate patterns, syntax differences, and design decisions rather than being optimized for production use. Topics covered (and planned): Active Directory administration, PowerShell module design, SaaS API integration, and general scripting patterns.

Target audience is mixed: some scripts target beginners learning PS fundamentals, others demonstrate intermediate/advanced patterns like module manifests, version-specific syntax, or REST API clients.

## Repo Structure

```
Active_Directory/     # Scripts targeting on-prem AD via the ActiveDirectory module
Modules/
  module_examples/    # Demonstrates psm1 + psd1 module design patterns
```

Future folders will be added per topic area (e.g., `API/`, `AzureAD/`, `Pester/`).

## Teaching Patterns

Scripts in this repo follow these conventions to make concepts clear:

- **Inline comments explain WHY**, not just what — especially for non-obvious choices, version-specific syntax, or PowerShell gotchas
- **PS 5.1 vs PS 7+ differences** are called out explicitly using `#region` blocks and comments showing both approaches side by side (see `Modules/module_examples/module_examples.psm1`)
- **Options are shown as commented alternatives** rather than deleted — e.g., `Export-ModuleMember` options in the module example show three approaches with trade-offs noted
- **Placeholder values** use `example.com` for domains, `Your Name` / `Your Org` for manifest fields — update for real environments

When adding new scripts: favor clarity over terseness. Include explanatory comments where a learner would benefit from knowing the reason behind a choice.

## Running Scripts

```powershell
# Dot-source a script to load its functions into session
. .\Active_Directory\New-ADUsers.ps1

# Then call the function
New-ADUsers -Path "C:\Scripts\CSVs\NewUsers.csv"

# Load a module via its manifest
Import-Module .\Modules\module_examples\module_examples.psd1

# Call an exported function
Get-UserStatus -Username 'jsmith'
```

No build step. No test framework yet. Validate manually or add Pester tests as that topic is introduced.

## Conventions

- Function names use PowerShell `Verb-Noun` with approved verbs — run `Get-Verb` to check
- Parameters use `[Parameter()]` attributes; mandatory params declared explicitly
- `UserPrincipalName` format: `FirstName.LastName@example.com` — update domain for real tenants
- Passwords generated via `New-RandomPassword`; pass `-ConvertToSecureString` when feeding AD cmdlets
- Module exports declared explicitly in both `Export-ModuleMember` (psm1) and `FunctionsToExport` (psd1) — wildcard exports are shown as commented alternatives for comparison

## Planned Topics

- SaaS API calls (REST clients, authentication patterns, pagination)
- Azure AD / Entra ID administration
- Pester unit and integration tests
- Error handling patterns
- Pipeline-friendly function design
