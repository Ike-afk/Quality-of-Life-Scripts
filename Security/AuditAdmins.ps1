<#
.SYNOPSIS
Exports members of the local Administrators group.

.DESCRIPTION
Retrieves all accounts that are members of the local Administrators group
on the current machine and exports the results to CSV.

Useful for:
- Security audits
- Detecting unauthorized admin accounts
- Baseline documentation

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Windows 10 / Server 2016 or newer
- Must be run locally (or via remote session)
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$GroupName = "Administrators"           # Local group to audit
$ReportPath = "C:\Reports\LocalAdmins.csv" # Where to save the report

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Ensure report folder exists
$ReportFolder = Split-Path $ReportPath -Parent
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

# Retrieve local group members
Get-LocalGroupMember -Group $GroupName |
Select-Object Name, ObjectClass |
Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Local admin audit report saved to $ReportPath" -ForegroundColor Green
