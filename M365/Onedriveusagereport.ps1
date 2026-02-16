#Pulls OneDrive for Business storage usage details for each user’s personal site.

Connect-SPOService -Url "https://YourTenant-admin.sharepoint.com"
Get-SPOSite -IncludePersonalSite $true | Select-Object Owner, StorageUsageCurrent |
Export-Csv "C:\Reports\OneDriveUsage.csv" -NoTypeInformation
