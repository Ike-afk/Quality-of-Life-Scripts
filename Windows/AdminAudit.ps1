<#
.SYNOPSIS
Exports members of the local Administrators group.

.DESCRIPTION
Retrieves all users and groups that are members of the local
Administrators group and exports the results to CSV.

Useful for:
- Security audits
- Privilege reviews
- Compliance checks

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$GroupName = "Administrators"            # Local group to audit
$ReportPath = "C:\Reports\LocalAdmins.csv"  # Where to save the CSV report

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Ensure report folder exists
$ReportFolder = Split-Path $ReportPath -Parent
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

Get-LocalGroupMember -Group $GroupName |
Select-Object Name, ObjectClass |
Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Local Administrators report saved to $ReportPath" -ForegroundColor Green

