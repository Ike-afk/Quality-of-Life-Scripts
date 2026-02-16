<#
.SYNOPSIS
Creates a daily scheduled reboot task.

.DESCRIPTION
Creates a Windows scheduled task that reboots the system daily
at the specified time.

IMPORTANT:
This will create or overwrite a scheduled task.
Run as Administrator.
#>
#
# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$TaskName = "NightlyReboot"
$Time = "03:00"         # 24-hour format (HH:MM)

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Create or overwrite scheduled task
schtasks /create `
    /sc daily `
    /tn $TaskName `
    /tr "shutdown /r /t 0" `
    /st $Time `
    /f

Write-Host "Scheduled daily reboot task '$TaskName' created for $Time." -ForegroundColor Green

