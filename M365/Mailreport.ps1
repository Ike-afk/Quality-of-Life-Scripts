#Generates mailbox size statistics across all Exchange Online users to help manage storage.

Connect-ExchangeOnline
Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics |
Select-Object DisplayName, TotalItemSize, ItemCount |
Export-Csv "C:\Reports\MailboxSizes.csv" -NoTypeInformation
