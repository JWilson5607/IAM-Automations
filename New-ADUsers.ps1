#Script to create new user manually or from CSV

function New-Adusers {
    
    #Install AD Module
    Import-Module ActiveDirectory
      
    #Define Parameters
    param ([Parameter(Mandatory=$false)]
        [string]$Path
    )
    
    #Get CSV Data
    $Path = "C:\Scripts\CSVs\NewUsers.csv"
    $NewUserData = Import-Csv -Path $Path 
    
    #Start Combining and Creating User
    foreach($n in $NewUserData){
        New-Aduser `
            -Name $($_.FirstName + " " + $_.LastName) `
            -GivenName $_.FirstName `
            -Surname $_.LastName `
            -EmployeeID $_.EmployeeID `
            -DisplayName $($_.FirstName + " " + $_.LastName) `
            -UserPrincipalName $($_.FirstName + "." + $_.LastName + "@wilson-networking.com") `
            -AccountPassword `
            -Enabled $true
    }
}