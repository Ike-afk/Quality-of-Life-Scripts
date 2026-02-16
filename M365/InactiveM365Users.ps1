<#
.SYNOPSIS
Generates a report of Microsoft 365 users who have not signed in within a defined number of days.

.DESCRIPTION
Connects to Microsoft Graph and checks each user for their most recent sign-in event.
Users with no sign-in record or a last sign-in older than the configured threshold are exported to CSV.

This is useful for:
- User cleanup
- License reclamation
- Stale account review

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Microsoft Graph PowerShell SDK installed (Microsoft.Graph)
- Permissions: User.Read.All, AuditLog.Read.All

#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$DaysInactive = 90                    # How many days without sign-in qualifies as inactive
$ReportFolder = "C:\Reports"          # Where to save the CSV report
$ReportName = "InactiveUsers.csv"   # Output CSV filename

# Scopes required for Graph sign-in log checks
$GraphScopes = @("User.Read.All", "AuditLog.Read.All")

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

$CutoffDate = (Get-Date).AddDays(-$DaysInactive)
Write-Host "Reporting users inactive since before: $CutoffDate" -ForegroundColor Cyan
Write-Host "Retrieving users... this may take a while in large tenants." -ForegroundColor Cyan

# Fetch all users
$AllUsers = Get-MgUser -All -Property "DisplayName,UserPrincipalName"

$InactiveUsers = foreach ($User in $AllUsers) {
    try {
        # Pull latest sign-in record for this user (may be slow at scale)
        $SignIn = Get-MgAuditLogSignIn -Filter "userPrincipalName eq '$($User.UserPrincipalName)'" -Top 1
        $LastLogon = $SignIn.CreatedDateTime

        if ($null -eq $LastLogon -or $LastLogon -lt $CutoffDate) {
            [PSCustomObject]@{
                DisplayName       = $User.DisplayName
                UserPrincipalName = $User.UserPrincipalName
                LastLogon         = $LastLogon
                InactiveDays      = if ($LastLogon) { [int]((New-TimeSpan -Start $LastLogon -End (Get-Date)).TotalDays) } else { $null }
            }
        }
    } catch {
        Write-Warning "Could not retrieve sign-in data for $($User.UserPrincipalName)"
    }
}

# Export results
$CsvPath = Join-Path $ReportFolder $ReportName
$InactiveUsers | Sort-Object LastLogon | Export-Csv -Path $CsvPath -NoTypeInformation

Write-Host "Report generated: $CsvPath" -ForegroundColor Green
