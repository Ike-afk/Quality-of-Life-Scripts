<#
.SYNOPSIS
Displays free and used disk space for all filesystem drives.

.DESCRIPTION
Retrieves disk usage information using Get-PSDrive and calculates
free and used space in GB.

Useful for:
- Identifying low storage
- Pre-backup checks
- General health monitoring

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ExportReport = $false                         # Set to $true to export CSV
$ReportPath = "C:\Reports\DiskSpace.csv"     # Used only if $ExportReport = $true

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

$data = Get-PSDrive -PSProvider FileSystem |
Select-Object `
    Name,
@{Name = "Free(GB)"; Expression = { [math]::Round($_.Free / 1GB, 2) } },
@{Name = "Used(GB)"; Expression = { [math]::Round($_.Used / 1GB, 2) } }

# Always show in terminal
$data

# Optional export
if ($ExportReport) {
    $Folder = Split-Path $ReportPath -Parent
    if (!(Test-Path $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    $data | Export-Csv -Path $ReportPath -NoTypeInformation
    Write-Host "Disk space report saved to $ReportPath" -ForegroundColor Green
}

