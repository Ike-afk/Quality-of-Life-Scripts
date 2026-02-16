#Quickly checks connectivity and latency to critical endpoints (Google DNS, Microsoft, etc.).

$targets = @("8.8.8.8", "1.1.1.1", "microsoft.com", "github.com")
foreach ($target in $targets) {
    $ping = Test-Connection -ComputerName $target -Count 2 -ErrorAction SilentlyContinue
    if ($ping) {
        Write-Host "$target - Online - Avg Latency: $($ping.AverageResponseTime) ms" -ForegroundColor Green
    } else {
        Write-Host "$target - Offline" -ForegroundColor Red
    }
}
