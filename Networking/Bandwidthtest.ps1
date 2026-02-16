#Tests local-to-remote network throughput using built-in PowerShel

$server = "speedtest.tele2.net"
Test-NetConnection -ComputerName $server -TraceRoute | Out-File "C:\Reports\BandwidthTest.txt"
Write-Host "Trace route saved to BandwidthTest.txt"
