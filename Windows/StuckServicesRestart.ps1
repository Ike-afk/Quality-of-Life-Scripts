# Restarts stopped or paused services

Get-Service | Where-Object { $_.Status -in @('Stopped', 'Paused') } | ForEach-Object {

    if ($_.Status -eq 'Stopped') {
        Start-Service -Name $_.Name -ErrorAction SilentlyContinue
    } elseif ($_.Status -eq 'Paused') {
        Resume-Service -Name $_.Name -ErrorAction SilentlyContinue
    }

}

Write-Host "Stopped and paused services have been handled."

