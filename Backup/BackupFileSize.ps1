#Scans a backup directory and reports files that are older than expected or too small (possible failed backups).
#Run daily to catch missed or incomplete backups.

$BackupPath = "D:\Backups"
$MinSizeMB = 100  # expected minimum backup file size
$MaxAgeDays = 2   # expected maximum backup age
$ReportPath = "C:\Reports\Backup_FileCheck.csv"

Get-ChildItem -Path $BackupPath -Recurse -File |
Where-Object {
    ($_.LastWriteTime -lt (Get-Date).AddDays(-$MaxAgeDays)) -or
    ($_.Length -lt ($MinSizeMB * 1MB))
} |
Select-Object FullName, @{N='Size(MB)';E={[math]::Round($_.Length/1MB,2)}}, LastWriteTime |
Export-Csv $ReportPath -NoTypeInformation

Write-Host "Backup verification report saved to $ReportPath"
