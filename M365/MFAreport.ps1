#Exports Multi-Factor Authentication (MFA) status for all users — critical for security audits.

Connect-MgGraph -Scopes "Directory.Read.All"
Get-MgUser -All | Select-Object DisplayName, UserPrincipalName, StrongAuthenticationMethods |
Export-Csv "C:\Reports\MFAStatus.csv" -NoTypeInformation
