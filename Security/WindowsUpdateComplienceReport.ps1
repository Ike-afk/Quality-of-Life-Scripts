<#
.SYNOPSIS
Exports installed Windows updates for patch compliance review.

.DESCRIPTION
Retrieves installed Windows hotfixes using Get-HotFix and exports
the results to CSV.

Useful for:
- Patch auditing
- Compliance documentation
- System baseline checks

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ReportPath = "C:\Reports\PatchCompliance.csv"  # Where to save the CSV report

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Ensure report folder exists
$ReportFolder = Split-Path $ReportPath -Parent
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

Get-HotFix |
Select-Object Description, HotFixID, InstalledOn |
Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Patch compliance report saved to $ReportPath" -ForegroundColor Green

