#Gathers IP address, subnet mask, gateway, and DNS info for all network interfaces.

Get-NetIPConfiguration |
Select-Object InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer |
Export-Csv "C:\Reports\NetworkConfig.csv" -NoTypeInformation
