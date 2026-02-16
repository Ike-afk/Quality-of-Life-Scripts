<#
.SYNOPSIS
Exports Microsoft Defender protection and update status.

.DESCRIPTION
Pulls Microsoft Defender status from Get-MpComputerStatus including:
- Service enabled state
- Antivirus/antispyware enabled state
- Quick scan age
- Signature last updated time

Exports results to CSV.

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Microsoft Defender available on the system
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ReportPath = "C:\Reports\DefenderStatus.csv"  # Where to save the CSV report

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Ensure report folder exists
$ReportFolder = Split-Path $ReportPath -Parent
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

Get-MpComputerStatus |
Select-Object `
    AMServiceEnabled,
AntispywareEnabled,
AntivirusEnabled,
QuickScanAge,
AntivirusSignatureLastUpdated |
Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Defender status report saved to $ReportPath" -ForegroundColor Green

