<#
.SYNOPSIS
Checks the health of Volume Shadow Copy Service (VSS) writers.

.DESCRIPTION
Runs "vssadmin list writers" and exports the results to a report file.

VSS writers must be in a "Stable" state for many backup systems to function properly.
This script is intended for pre-backup validation or scheduled monitoring.

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.NOTES
Requires:
- Administrative privileges
- vssadmin available (built into Windows)
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ReportPath = "C:\Reports\VSS_HealthReport.txt"  # Where to save the VSS health report

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Verify vssadmin is available
if (-not (Get-Command vssadmin -ErrorAction SilentlyContinue)) {
    Write-Error "vssadmin is not available on this system."
    exit 1
}

# Ensure report folder exists
$ReportFolder = Split-Path $ReportPath -Parent
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

# Run VSS writer check
vssadmin list writers > $ReportPath

Write-Host "VSS Writer Health Report saved to $ReportPath"
