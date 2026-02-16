<#
.SYNOPSIS
Reports backup files that appear stale or incomplete.

.DESCRIPTION
Scans a backup directory recursively and reports files that are either:
- Older than the expected maximum age (possible missed backup), OR
- Smaller than the expected minimum size (possible failed/incomplete backup)

Results are exported to a CSV report.

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.NOTES
Run as: Standard user (Admin not required unless backup path requires it)
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$BackupPath = "D:\Backups"                       # Folder where backups are stored
$MinSizeMB = 100                                # Minimum expected backup file size (MB)
$MaxAgeDays = 2                                  # Maximum allowed backup age (days)
$ReportPath = "C:\Reports\Backup_FileCheck.csv"  # Where to save the report (CSV)

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Validate backup path
if (!(Test-Path $BackupPath)) {
    Write-Error "Backup path does not exist: $BackupPath"
    exit 1
}

# Ensure report folder exists
$ReportFolder = Split-Path $ReportPath -Parent
if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

# Scan for problematic backups and export report
Get-ChildItem -Path $BackupPath -Recurse -File |
Where-Object {
    ($_.LastWriteTime -lt (Get-Date).AddDays(-$MaxAgeDays)) -or
    ($_.Length -lt ($MinSizeMB * 1MB))
} |
Select-Object `
    FullName,
@{ Name = 'Size(MB)'; Expression = { [math]::Round($_.Length / 1MB, 2) } },
LastWriteTime |
Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Backup verification report saved to $ReportPath"

