#Scans specified ports on a host to test firewall and service availability.

$ComputerName = "localhost"
$Ports = 22,80,443,3389
foreach ($port in $Ports) {
    $test = Test-NetConnection -ComputerName $ComputerName -Port $port
    if ($test.TcpTestSucceeded) {
        Write-Host "Port $port is OPEN on $ComputerName" -ForegroundColor Green
    } else {
        Write-Host "Port $port is CLOSED on $ComputerName" -ForegroundColor Red
    }
}
