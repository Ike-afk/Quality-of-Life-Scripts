# Verifies whether Remote Desktop Protocol (RDP) is enabled
# Get RDP status from the registry

$rdpStatus = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections"

# Display RDP status in color
if ($rdpStatus.fDenyTSConnections -eq 0) {
    Write-Host "RDP is ENABLED" -ForegroundColor Green
} else {
    Write-Host "RDP is DISABLED" -ForegroundColor Red
}

