#Reports on Windows Defender Firewall configuration to ensure consistent protection policies.

Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
