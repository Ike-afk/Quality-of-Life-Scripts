<#
.SYNOPSIS
Exports current DHCP IPv4 leases from the specified DHCP server.

.DESCRIPTION
Retrieves active DHCP IPv4 leases and exports them to CSV.
Useful for troubleshooting:
- IP conflicts
- Lease assignments
- Address usage
- Rogue devices

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Must be run on a DHCP server
  OR
- DHCP Server tools installed (RSAT)
- Administrative privileges
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$DhcpServer = "localhost"                 # Change if querying a remote DHCP server
$ReportPath = "C:\Reports\DHCP_Leases.csv" # Where to save the CSV report

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Ensure report folder exists
$ReportFolder = Split-Path $ReportPath -Parent
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

# Retrieve DHCP leases
Get-DhcpServerv4Lease -ComputerName $DhcpServer |
Select-Object IPAddress, HostName, ClientId, AddressState, LeaseExpiryTime |
Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "DHCP lease report saved to $ReportPath"

