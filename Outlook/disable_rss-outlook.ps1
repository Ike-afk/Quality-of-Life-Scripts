# Disable RSS Feeds in Outlook for all users (requires admin)
# Save this as disable_rss_outlook.ps1

Write-Host "Disabling RSS feeds in Outlook..."

# Registry path for Outlook RSS settings (applies to all Office versions)
$officeVersions = @("16.0", "15.0", "14.0")  # Outlook 2016/2019/365, 2013, 2010

foreach ($version in $officeVersions) {
    $keyPath = "HKCU:\Software\Policies\Microsoft\Office\$version\Outlook\Options"
    if (-not (Test-Path $keyPath)) {
        New-Item -Path $keyPath -Force | Out-Null
    }

    # Disable RSS feature
    New-ItemProperty -Path $keyPath -Name "DisableRSS" -PropertyType DWord -Value 1 -Force | Out-Null

    # Disable synchronization with the Windows Common Feed List
    $syncKey = "HKCU:\Software\Policies\Microsoft\Office\$version\Outlook\Options\RSS"
    if (-not (Test-Path $syncKey)) {
        New-Item -Path $syncKey -Force | Out-Null
    }
    New-ItemProperty -Path $syncKey -Name "DisableSync" -PropertyType DWord -Value 1 -Force | Out-Null
}

Write-Host "RSS feeds have been disabled in Outlook. Please restart Outlook for changes to take effect."