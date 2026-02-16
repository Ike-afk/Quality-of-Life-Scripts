<#
.SYNOPSIS
Exports user logon (4624) and logoff (4634) events from the Security log.

.DESCRIPTION
Pulls Security log events for:
- 4624 = Logon
- 4634 = Logoff

Exports results to CSV by default.
Set $ExportReport = $false if you do NOT want a CSV file.

.NOTES
Requires permission to read Security log (often Administrator).
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$MaxEvents = 500                             # How many newest events to retrieve
$ExportReport = $true                           # DEFAULT = $true
# Set to $false IF YOU DO NOT WANT A CSV FILE
$ReportPath = "C:\Reports\UserLogons.csv"     # CSV save location

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Get logon/logoff events (newest first)
$data = Get-EventLog -LogName Security -Newest $MaxEvents |
Where-Object { $_.EventID -in 4624, 4634 } |
Select-Object `
    TimeGenerated,
EventID,
@{Name = "User"; Expression = { $_.ReplacementStrings[5] } },
Message

# Always show in terminal
$data

# Export automatically unless disabled
if ($ExportReport) {

    $Folder = Split-Path $ReportPath -Parent
    if (!(Test-Path $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    $data | Export-Csv -Path $ReportPath -NoTypeInformation
    Write-Host "User logon/logoff report saved to $ReportPath" -ForegroundColor Green
}

