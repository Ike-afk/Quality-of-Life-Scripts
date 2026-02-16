#Lists all users and groups with local administrator privileges — critical for security compliance.

Get-LocalGroupMember -Group "Administrators" |
Select-Object Name, ObjectClass |
Export-Csv "C:\Reports\LocalAdmins.csv" -NoTypeInformation
