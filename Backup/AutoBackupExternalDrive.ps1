#Copies critical folders to an external drive or network share and logs the results.
#Use this for quick, lightweight local backups outside of a formal backup system.

$Source = "C:\Data"
$Destination = "\\NAS01\Backups\Workstation1"
$Log = "C:\Reports\BackupCopy_$(Get-Date -Format yyyy-MM-dd).log"

Robocopy $Source $Destination /MIR /R:2 /W:5 /LOG:$Log
Write-Host "Backup completed. Log saved to $Log"
