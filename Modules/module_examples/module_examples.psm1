# module_examples.psm1
# Demonstrates PS 5.1 vs PS 7+ syntax differences and export control options.
# Load this module: Import-Module .\Modules\module_examples\module_examples.psd1

# Module-scope variable — exported via VariablesToExport in psd1.
# Consumers access it directly after import: $DefaultDomain
# Defined at module scope (no $script: prefix) so the module system can expose it.
$DefaultDomain = 'example.com'

#region PS 5.1 Compatible Functions

function Get-UserStatus {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Username
    )

    $lookup = @{
        jsmith  = 'Active'
        bjones  = 'Disabled'
        kwilson = 'Locked'
    }

    if ($lookup.ContainsKey($Username)) {
        [PSCustomObject]@{
            Username = $Username
            Status   = $lookup[$Username]
        }
    } else {
        Write-Warning "User '$Username' not found."
        $null
    }
}

function New-UserAccount {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FirstName,
        [Parameter(Mandatory=$true)]
        [string]$LastName,
        [Parameter(Mandatory=$false)]
        [string]$Domain = 'example.com'
    )

    [PSCustomObject]@{
        DisplayName       = "$FirstName $LastName"
        UserPrincipalName = "$FirstName.$LastName@$Domain"
        CreatedAt         = Get-Date
    }
}

#endregion

#region PS 7+ Only Functions
# Add #Requires -Version 7 at top of file to enforce version at load time.
# Comment out this entire region if targeting PS 5.1.

function Resolve-UserStatus {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Username,
        [string]$Department = $null
    )

    $lookup = @{ jsmith = 'Active'; bjones = 'Disabled' }

    # Ternary operator — PS 7+ only. PS 5.1 equivalent: if ($lookup.ContainsKey($Username)) { ... } else { 'Not Found' }
    $status = $lookup.ContainsKey($Username) ? $lookup[$Username] : 'Not Found'

    # Null-coalescing assignment — PS 7+ only. PS 5.1 equivalent: if ($null -eq $Department) { $Department = 'Unassigned' }
    $Department ??= 'Unassigned'

    [PSCustomObject]@{
        Username   = $Username
        Status     = $status
        Department = $Department
    }
}

#endregion

# Alias — exported via AliasesToExport in psd1.
# Consumers call: gus -Username 'jsmith'  (same as Get-UserStatus -Username 'jsmith')
Set-Alias -Name 'gus' -Value 'Get-UserStatus'

# --- Export Control ---
# OPTION 1 (active): Explicit list. Only named functions/variables/aliases are callable by consumers.
# Best practice: keeps internal helper functions private even if added later.
Export-ModuleMember -Function 'Get-UserStatus', 'New-UserAccount', 'Resolve-UserStatus' `
                    -Variable 'DefaultDomain' `
                    -Alias 'gus'

# OPTION 2 (commented): Wildcard — exports every function defined in this file.
# Simpler, but exposes all functions including any private helpers.
# Export-ModuleMember -Function '*' -Variable '*' -Alias '*'

# OPTION 3 (commented): Omit Export-ModuleMember entirely — behaves identically to Option 2.
# Not recommended: intent is implicit rather than declared.
