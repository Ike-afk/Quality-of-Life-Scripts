#Lists current DHCP leases on local interfaces (useful for troubleshooting IP conflicts).

Get-DhcpServerv4Lease -ComputerName localhost |
Select-Object IPAddress, HostName, ClientId, AddressState, LeaseExpiryTime |
Export-Csv "C:\Reports\DHCP_Leases.csv" -NoTypeInformation
