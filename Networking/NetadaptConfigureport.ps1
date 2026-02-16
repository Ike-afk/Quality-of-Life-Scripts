<#
.SYNOPSIS
Exports IPv4 network configuration details for all network interfaces.

.DESCRIPTION
Retrieves IP address, default gateway, and DNS server information
for all network adapters and exports the results to CSV.

Useful for:
- Network troubleshooting
- Documentation
- Baseline configuration capture

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Windows 8 / Server 2012 or newer
- PowerShell 3.0+
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ReportPath = "C:\Reports\NetworkConfig.csv"  # Where to save the CSV report

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Ensure report folder exists
$ReportFolder = Split-Path $ReportPath -Parent
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

Get-NetIPConfiguration |
Select-Object `
    InterfaceAlias,
IPv4Address,
IPv4DefaultGateway,
DNSServer |
Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Network configuration report saved to $ReportPath"
