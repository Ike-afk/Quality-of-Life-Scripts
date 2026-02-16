$events = Get-WinEvent -LogName Security -MaxEvents 50 |
    Where-Object {
        $_.Message -match "vssadmin" -or
        $_.Message -match "shadowcopy" -or
        $_.Message -match "wmic shadowcopy"
    }

if ($events) {
    Write-Output "Warning: shadow copy tampering detected"
}