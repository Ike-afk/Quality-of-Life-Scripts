#Automatically restarts any Windows services that are stopped or paused

Get-Service | Where-Object {$_.Status -in @('Stopped','Paused')} | ForEach-Object { Restart-Service -Name $_.Name -Force }
