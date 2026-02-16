<#
.SYNOPSIS
Checks if RDP is enabled on this computer.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY (usually you change nothing)
# ============================================================

$RegistryPath = "HKLM:\System\CurrentControlSet\Control\Terminal Server"
$ValueName = "fDenyTSConnections"

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

$rdpStatus = Get-ItemProperty -Path $RegistryPath -Name $ValueName

if ($rdpStatus.$ValueName -eq 0) {
    Write-Host "RDP is ENABLED" -ForegroundColor Green
} else {
    Write-Host "RDP is DISABLED" -ForegroundColor Red
}
