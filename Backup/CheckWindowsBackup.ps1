#Checks the results of the last Windows Server Backup (or workstation backup) job for success/failure.

$Status = wbadmin get versions
if ($Status -match "Version identifier") {
    Write-Host "✅ Backups found:" -ForegroundColor Green
    $Status
} else {
    Write-Host "❌ No successful backups found!" -ForegroundColor Red
}
