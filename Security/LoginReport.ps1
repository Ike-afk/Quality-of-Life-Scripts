<#
.SYNOPSIS
Exports recent failed logon attempts from the Security event log.

.DESCRIPTION
Retrieves Security event ID 4625 (failed logon attempts) and exports
the most recent entries to CSV.

Useful for:
- Brute force detection
- Account lockout investigation
- Security auditing

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Must be run as Administrator
- Security log access required
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$MaxEvents = 50                               # Number of failed logon events to retrieve
$ReportPath = "C:\Reports\FailedLogins.csv"    # Where to save the CSV report

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Ensure report folder exists
$ReportFolder = Split-Path $ReportPath -Parent
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

# Retrieve failed logon events
Get-WinEvent -FilterHashtable @{LogName = 'Security'; Id = 4625 } -MaxEvents $MaxEvents |
Select-Object `
    TimeCreated,
@{Name = 'Username'; Expression = { $_.Properties[5].Value } },
Message |
Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Failed logon report saved to $ReportPath" -ForegroundColor Green
