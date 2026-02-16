<#
.SYNOPSIS
Displays Windows Defender Firewall profile configuration.

.DESCRIPTION
Retrieves firewall profile settings including:
- Profile name
- Enabled status
- Default inbound action
- Default outbound action

By default, results are exported to CSV.
Set $ExportReport = $false if you do NOT want a CSV.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ExportReport = $true                            # DEFAULT = $true
# Set to $false if you do NOT want CSV
$ReportPath = "C:\Reports\FirewallStatus.csv"  # CSV save location

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

$data = Get-NetFirewallProfile |
Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction

# Always display in terminal
$data

# Auto export (unless disabled)
if ($ExportReport) {

    $Folder = Split-Path $ReportPath -Parent
    if (!(Test-Path $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    $data | Export-Csv -Path $ReportPath -NoTypeInformation
    Write-Host "Firewall profile report saved to $ReportPath" -ForegroundColor Green
}

