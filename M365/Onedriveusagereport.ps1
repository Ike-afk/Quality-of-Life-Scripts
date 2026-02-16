<#
.SYNOPSIS
Exports OneDrive for Business storage usage for personal sites.

.DESCRIPTION
Connects to SharePoint Online (SPO) admin center and retrieves storage usage
for personal sites (OneDrive). Exports owner and current storage usage to CSV.

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- SharePoint Online Management Shell installed (Microsoft.Online.SharePoint.PowerShell)
- SharePoint admin permissions
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$SPOAdminUrl = "https://YourTenant-admin.sharepoint.com"  # <-- PUT your real tenant admin URL here
$ReportFolder = "C:\Reports"                                # <-- Where to save the report
$ReportName = "OneDriveUsage.csv"                         # <-- Output CSV filename

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Verify SPO module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
    Write-Error "SharePoint Online module not installed. Install: Install-Module Microsoft.Online.SharePoint.PowerShell -Scope AllUsers"
    exit 1
}

Import-Module Microsoft.Online.SharePoint.PowerShell -ErrorAction Stop

# Ensure report folder exists
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

$CsvPath = Join-Path $ReportFolder $ReportName

# Connect to SharePoint Online
Write-Host "Connecting to SharePoint Online..." -ForegroundColor Cyan
Connect-SPOService -Url $SPOAdminUrl

Write-Host "Retrieving OneDrive personal sites..." -ForegroundColor Cyan

# Pull OneDrive usage
Get-SPOSite -IncludePersonalSite $true -Limit All |
Select-Object `
    Owner,
StorageUsageCurrent,
Url |
Export-Csv -Path $CsvPath -NoTypeInformation

Write-Host "OneDrive usage report saved to $CsvPath" -ForegroundColor Green

