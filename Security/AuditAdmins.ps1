#Audits all local admin accounts to detect unauthorized access.

Get-LocalGroupMember -Group "Administrators" |
Select-Object Name, ObjectClass |
Export-Csv "C:\Reports\LocalAdmins.csv" -NoTypeInformation
