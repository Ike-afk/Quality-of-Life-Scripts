#Exports a list of all users assigned with licenses — ideal for license management and billing reviews.

Connect-MgGraph -Scopes "User.Read.All"
Get-MgUser -All | Where-Object {$_.AssignedLicenses.Count -gt 0} |
Select-Object DisplayName, UserPrincipalName, @{N="Licenses";E={$_.AssignedLicenses.Count}}
