<#
.SYNOPSIS
Generates a report of all Microsoft 365 users assigned at least one license.

.DESCRIPTION
Connects to Microsoft Graph and retrieves all users with one or more assigned licenses.
Exports the results to a CSV file for license management, billing review,
or cleanup analysis.

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Microsoft Graph PowerShell SDK installed (Microsoft.Graph)
- Permission: User.Read.All

#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ReportFolder = "C:\Reports"               # Where to save the report
$ReportName = "LicensedUsers.csv"        # Output CSV filename
$GraphScopes = @("User.Read.All")         # Required Graph permissions

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Verify Microsoft Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Error "Microsoft.Graph module is not installed. Install it first: Install-Module Microsoft.Graph -Scope AllUsers"
    exit 1
}

Import-Module Microsoft.Graph -ErrorAction Stop

# Connect to Microsoft Graph
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes $GraphScopes | Out-Null

# Ensure report folder exists
if (-not (Test-Path $ReportFolder)) {
    New-Item -Path $ReportFolder -ItemType Directory -Force | Out-Null
}

Write-Host "Retrieving licensed users..." -ForegroundColor Cyan

# Retrieve users with licenses
$LicensedUsers = Get-MgUser -All -Property "DisplayName,UserPrincipalName,AssignedLicenses" |
Where-Object { $_.AssignedLicenses.Count -gt 0 } |
Select-Object `
    DisplayName,
UserPrincipalName,
@{ Name = "LicenseCount"; Expression = { $_.AssignedLicenses.Count } }

# Export results
$CsvPath = Join-Path $ReportFolder $ReportName
$LicensedUsers | Export-Csv -Path $CsvPath -NoTypeInformation

Write-Host "Report generated: $CsvPath" -ForegroundColor Green
