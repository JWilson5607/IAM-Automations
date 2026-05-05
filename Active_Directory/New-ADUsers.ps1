#Script to create new user manually or from CSV

function New-ADUsers {
    param (
        [Parameter(Mandatory=$false)]
        [string]$Path = "C:\Scripts\CSVs\NewUsers.csv"
    )

    Import-Module ActiveDirectory

    $NewUserData = Import-Csv -Path $Path

    foreach ($n in $NewUserData) {
        New-ADUser `
            -Name "$($n.FirstName) $($n.LastName)" `
            -GivenName $n.FirstName `
            -Surname $n.LastName `
            -EmployeeID $n.EmployeeID `
            -DisplayName "$($n.FirstName) $($n.LastName)" `
            -UserPrincipalName "$($n.FirstName).$($n.LastName)@example.com" `
            -AccountPassword (New-RandomPassword -ConvertToSecureString) `
            -Enabled $true
    }
}
