<#
.SYNOPSIS
Checks connectivity and average latency to specified endpoints.

.DESCRIPTION
Uses Test-Connection to verify whether target endpoints are reachable
and calculates average response time (latency).

Useful for:
- Quick connectivity validation
- ISP troubleshooting
- Baseline network checks

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$Targets = @(
    "8.8.8.8",
    "1.1.1.1",
    "microsoft.com",
    "github.com"
)  # Add or remove endpoints as needed

$PingCount = 2  # Number of ICMP pings per target

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

foreach ($Target in $Targets) {

    $PingResults = Test-Connection -ComputerName $Target -Count $PingCount -ErrorAction SilentlyContinue

    if ($PingResults) {

        $AvgLatency = [math]::Round(
            ($PingResults | Measure-Object -Property ResponseTime -Average).Average,
            2
        )

        Write-Host "$Target - Online - Avg Latency: $AvgLatency ms" -ForegroundColor Green
    } else {
        Write-Host "$Target - Offline" -ForegroundColor Red
    }
}
