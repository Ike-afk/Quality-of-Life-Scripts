<#
.SYNOPSIS
Retrieves recent Error and Critical events from the System log.

.DESCRIPTION
Pulls the newest System log errors and critical events.
By default, results are exported to CSV.
If you do NOT want a CSV file, set $ExportReport = $false.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$MaxEvents = 100                            # Number of newest events to retrieve
$ExportReport = $true                          # DEFAULT = $true
# Set to $false if you DO NOT want a CSV
$ReportPath = "C:\Reports\SystemErrors.csv"  # CSV save location

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

$data = Get-EventLog -LogName System -EntryType Error, Critical -Newest $MaxEvents |
Select-Object TimeGenerated, Source, EventID, Message

# Always show in terminal
$data

# Export automatically (unless disabled)
if ($ExportReport) {

    $Folder = Split-Path $ReportPath -Parent
    if (!(Test-Path $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    $data | Export-Csv -Path $ReportPath -NoTypeInformation
    Write-Host "System error report saved to $ReportPath" -ForegroundColor Green
}

