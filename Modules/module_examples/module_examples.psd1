# module_examples.psd1
# Module manifest — controls metadata, versioning, and a second layer of export control.
# Generate your own GUID with: [System.Guid]::NewGuid().ToString()
# Load this module: Import-Module .\Modules\module_examples\module_examples.psd1

@{
    RootModule        = 'module_examples.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '7f3a1b2c-4d5e-6f78-9abc-def012345678'
    Author            = 'Your Name'
    CompanyName       = 'Your Org'
    Description       = 'Example module demonstrating psm1/psd1 patterns for IAM automations.'

    # Minimum PS version required to load this module.
    # Change to '7.0' if using PS 7+ features from the psm1.
    PowerShellVersion = '5.1'

    # --- FunctionsToExport acts as a second gate alongside Export-ModuleMember in the psm1.
    # A function must be allowed by BOTH to be callable by consumers.
    # If they conflict (e.g., psm1 exports 'Get-UserStatus' but psd1 doesn't list it), the function is blocked.

    # OPTION 1 (active): Explicit list — declare exactly what is public.
    # Must stay in sync with Export-ModuleMember in module_examples.psm1.
    FunctionsToExport = @(
        'Get-UserStatus'
        'New-UserAccount'
        'Resolve-UserStatus'
    )

    # OPTION 2 (commented): Wildcard — allows anything the psm1 exports through.
    # Simpler but loses the psd1 as a safety net for accidental exports.
    # FunctionsToExport = '*'

    # CmdletsToExport: For compiled binary modules (.dll) only — not script modules (.psm1).
    # Script modules define functions, not cmdlets. Binary modules written in C# define cmdlets.
    # Example (binary module): CmdletsToExport = @('Get-ADUserFast', 'Set-ADUserFast')
    CmdletsToExport   = @()

    # VariablesToExport: Exposes module-scope variables to consumers after Import-Module.
    # The variable must also be exported via Export-ModuleMember -Variable in the psm1.
    # Consumer usage after import: $DefaultDomain  (no module prefix needed)
    # Caution: exported variables are mutable by consumers — prefer functions for encapsulation.
    VariablesToExport = @('DefaultDomain')
    # VariablesToExport = @()    # empty  = no variables exposed
    # VariablesToExport = '*'    # wildcard = all module-scope variables exposed

    # AliasesToExport: Exposes aliases defined in psm1 via Set-Alias / New-Alias.
    # The alias must also be exported via Export-ModuleMember -Alias in the psm1.
    # Consumer usage after import: gus -Username 'jsmith'  (resolves to Get-UserStatus)
    # Use aliases sparingly — they pollute the consumer's session namespace.
    AliasesToExport   = @('gus')
    # AliasesToExport = @()     # empty    = no aliases exposed
    # AliasesToExport = '*'     # wildcard = all aliases defined in psm1 exposed

    # PrivateData/PSData: Publishing metadata consumed by PowerShell Gallery and Publish-Module.
    # Not required for local use — only relevant when publishing externally.
    PrivateData = @{
        PSData = @{
            # Searchable keywords on PSGallery
            Tags                     = @('IAM', 'ActiveDirectory', 'Identity')

            # Link to source repository
            ProjectUri               = 'https://github.com/your-org/IAM-Automations'

            # Link to license file — required for RequireLicenseAcceptance = $true
            LicenseUri               = 'https://github.com/your-org/IAM-Automations/blob/main/LICENSE'

            # Shown on the PSGallery version page — what changed in this release
            ReleaseNotes             = 'Initial release. Includes Get-UserStatus, New-UserAccount, Resolve-UserStatus.'

            # Marks module as prerelease on PSGallery. Remove or leave empty for stable.
            # Prerelease               = 'beta'

            # When true, Install-Module forces user to accept license before completing.
            # RequireLicenseAcceptance = $false
        }
    }
}
