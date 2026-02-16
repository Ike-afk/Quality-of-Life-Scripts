#Extracts recent critical and error events from the System log to help diagnose system issues.

Get-EventLog -LogName System -EntryType Error, Critical -Newest 100 |
Select-Object TimeGenerated, Source, EventID, Message |
Export-Csv "C:\Reports\SystemErrors.csv" -NoTypeInformation
