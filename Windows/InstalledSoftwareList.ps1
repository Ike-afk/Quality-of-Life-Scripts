<#
.SYNOPSIS
Generates an installed software inventory report.
CSV export is ENABLED by default.
Set $ExportReport = $false if you do NOT want a CSV file.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ExportReport = $true   # DEFAULT = $true
# Set to $false IF YOU DO NOT WANT A CSV FILE

$ReportPath = "C:\Reports\Installed_Software.csv"

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

$paths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

# Collect all installed apps first
$allApps = @()

foreach ($path in $paths) {
    $allApps += Get-ItemProperty $path -ErrorAction SilentlyContinue
}

# Filter and format
$data = $allApps |
Where-Object { $_.DisplayName } |
Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Sort-Object DisplayName -Unique

# Always display in terminal
$data

# Export automatically unless disabled
if ($ExportReport) {

    $Folder = Split-Path $ReportPath -Parent
    if (!(Test-Path $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    $data | Export-Csv -Path $ReportPath -NoTypeInformation
    Write-Host "Installed software report saved to $ReportPath" -ForegroundColor Green
}

