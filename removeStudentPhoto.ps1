<# 
Script to remove user photo from all students

Requires following powershell modules
    MSOnline
    ExchangeOnline

Script gets all the users with the Student OfficeSubscription Licence assigned to them
and removes the photo from those accounts
 #>

# Connect to the required M365 services
Connect-MsolService
Connect-ExchangeOnline

# Get all the user accounts with "OFFICESUBSCRPTION_STUDENT" assigned
$Students = (Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match "OFFICESUBSCRIPTION_STUDENT"}).UserPrincipalName

# For each student, check if photo exists, and if it does remove the photo.
$Students | ForEach-Object { 
    if ((Get-EXOMailbox -Identity $_ -Properties HasPicture).HasPicture) {
        Write-Output "Removing photo for $_"
        Remove-UserPhoto -Identity $_ -Confirm:$false
    }
    
}