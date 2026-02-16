#Creates a daily scheduled reboot to maintain uptime and clear system resources automatically.

schtasks /create /sc daily /tn "NightlyReboot" /tr "shutdown /r /t 0" /st 03:00
