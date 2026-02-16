<#
.SYNOPSIS
Simple bandwidth test (download speed).
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$TestFileUrl = "https://speed.hetzner.de/100MB.bin"  # Change to 10MB/1GB if desired
$DownloadPath = "$env:TEMP\BandwidthTest.bin"         # Temporary file location

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

$start = Get-Date

Invoke-WebRequest -Uri $TestFileUrl -OutFile $DownloadPath -UseBasicParsing

$elapsed = (Get-Date) - $start
$bytes = (Get-Item $DownloadPath).Length

# bits/sec -> megabits/sec
$mbps = [math]::Round((($bytes * 8) / $elapsed.TotalSeconds) / 1MB, 2)

Write-Host "Downloaded $([math]::Round($bytes/1MB,2)) MB in $([math]::Round($elapsed.TotalSeconds,2)) seconds"
Write-Host "Average Download Speed: $mbps Mbps"

Remove-Item $DownloadPath -Force

