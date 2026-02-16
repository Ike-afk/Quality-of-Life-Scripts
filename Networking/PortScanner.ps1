<#
.SYNOPSIS
Tests specified TCP ports on a target host.

.DESCRIPTION
Uses Test-NetConnection to check whether specified ports are open
on a given host. Useful for:

- Firewall validation
- Service availability checks
- Quick connectivity troubleshooting

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ComputerName = "localhost"   # Target host (IP or DNS name)
$Ports = 22, 80, 443, 3389 # Ports to test

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

foreach ($Port in $Ports) {

    $Test = Test-NetConnection -ComputerName $ComputerName -Port $Port -WarningAction SilentlyContinue

    if ($Test.TcpTestSucceeded) {
        Write-Host "Port $Port is OPEN on $ComputerName" -ForegroundColor Green
    } else {
        Write-Host "Port $Port is CLOSED on $ComputerName" -ForegroundColor Red
    }
}
