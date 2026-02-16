<#
.SYNOPSIS
Detects potential shadow copy tampering activity in recent Windows Security events.

.DESCRIPTION
Scans the most recent Security log events and flags entries containing
keywords commonly associated with shadow copy manipulation (vssadmin/shadowcopy/wmic shadowcopy).

This script DETECTS only — it does not block or stop processes.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$MaxEvents = 200                               # How many Security events to scan
$Keywords = @("vssadmin", "shadowcopy", "wmic shadowcopy")
$ReportPath = "C:\Reports\ShadowCopyTamperHits.csv"  # Optional report output (set to "" to disable)

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

$events = Get-WinEvent -LogName Security -MaxEvents $MaxEvents |
Where-Object {
    $msg = $_.Message
    $Keywords | ForEach-Object { if ($msg -match $_) { $true } } | Where-Object { $_ } | Select-Object -First 1
}

if ($events) {
    Write-Host "WARNING: Possible shadow copy tampering detected!" -ForegroundColor Red

    $hits = $events | Select-Object TimeCreated, Id, ProviderName, LevelDisplayName, Message

    # Export if report path provided
    if ($ReportPath -and $ReportPath.Trim() -ne "") {
        $folder = Split-Path $ReportPath -Parent
        if (!(Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }

        $hits | Export-Csv -Path $ReportPath -NoTypeInformation
        Write-Host "Report saved to $ReportPath" -ForegroundColor Yellow
    }

    # Print a quick summary to console
    $hits | Format-Table -AutoSize
} else {
    Write-Host "No shadow copy tampering keywords found in the last $MaxEvents Security events." -ForegroundColor Green
}
