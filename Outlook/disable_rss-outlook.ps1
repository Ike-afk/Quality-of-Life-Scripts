<#
.SYNOPSIS
Disables RSS feeds in Microsoft Outlook via registry policy settings.

.DESCRIPTION
Creates or updates registry policy keys to disable:
- RSS feature in Outlook
- Synchronization with Windows Common Feed List

Applies to specified Office versions under HKCU (current user).

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Run as user (HKCU scope)
- Outlook restart required for changes to apply
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$OfficeVersions = @(
    "16.0",  # Outlook 2016 / 2019 / 365
    "15.0",  # Outlook 2013
    "14.0"   # Outlook 2010
)

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

Write-Host "Disabling RSS feeds in Outlook..." -ForegroundColor Cyan

foreach ($Version in $OfficeVersions) {

    $KeyPath = "HKCU:\Software\Policies\Microsoft\Office\$Version\Outlook\Options"

    if (-not (Test-Path $KeyPath)) {
        New-Item -Path $KeyPath -Force | Out-Null
    }

    # Disable RSS feature
    New-ItemProperty -Path $KeyPath `
        -Name "DisableRSS" `
        -PropertyType DWord `
        -Value 1 `
        -Force | Out-Null

    # Disable synchronization with Windows Common Feed List
    $SyncKey = "$KeyPath\RSS"

    if (-not (Test-Path $SyncKey)) {
        New-Item -Path $SyncKey -Force | Out-Null
    }

    New-ItemProperty -Path $SyncKey `
        -Name "DisableSync" `
        -PropertyType DWord `
        -Value 1 `
        -Force | Out-Null
}

Write-Host "RSS feeds have been disabled. Restart Outlook for changes to take effect." -ForegroundColor Green
