#Extracts recent failed logon attempts for security analysis.

Get-WinEvent -FilterHashtable @{LogName='Security';Id=4625} -MaxEvents 50 |
Select-Object TimeCreated, @{Name='Username';Expression={$_.Properties[5].Value}}, Message |
Export-Csv "C:\Reports\FailedLogins.csv" -NoTypeInformation
