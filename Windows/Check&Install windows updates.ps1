<#
.SYNOPSIS
Installs all pending Windows Updates and reboots if required.

.DESCRIPTION
Uses PSWindowsUpdate module to:
- Retrieve available updates
- Accept and install all updates
- Automatically reboot if required

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Run as Administrator
- Internet access (for module installation if needed)
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$AutoReboot = $true   # Set to $false if you do NOT want automatic reboot

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Install module if not present
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host "Installing PSWindowsUpdate module..." -ForegroundColor Yellow
    Install-Module PSWindowsUpdate -Force -Scope CurrentUser
}

Import-Module PSWindowsUpdate -ErrorAction Stop

Write-Host "Checking for available Windows updates..." -ForegroundColor Cyan

if ($AutoReboot) {
    Get-WindowsUpdate -AcceptAll -Install -AutoReboot
} else {
    Get-WindowsUpdate -AcceptAll -Install
}

Write-Host "Windows update process completed." -ForegroundColor Green

