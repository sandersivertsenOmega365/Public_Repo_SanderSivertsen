# Stop the Print Spooler service
Stop-Service -Name "Spooler" -Force

# Optional: Disable it from starting automatically
Set-Service -Name "Spooler" -StartupType Disabled
