# ================================
# Setup Script for Azure Image
# ================================

# ---------------------
# 1. Create Firewall Rule (TCP & UDP on port 55231)
# ---------------------
$ruleName = "Sander_Test"
$port = 55231

Write-Output "Creating firewall rules for TCP and UDP on port $port..."

# TCP Rule
if (-not (Get-NetFirewallRule -DisplayName "$ruleName - TCP" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -DisplayName "$ruleName - TCP" `
                        -Direction Inbound `
                        -Action Allow `
                        -Protocol TCP `
                        -LocalPort $port
}

# UDP Rule
if (-not (Get-NetFirewallRule -DisplayName "$ruleName - UDP" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -DisplayName "$ruleName - UDP" `
                        -Direction Inbound `
                        -Action Allow `
                        -Protocol UDP `
                        -LocalPort $port
}

# ---------------------
# 2. Stop and Disable Print Spooler Service
# ---------------------
Write-Output "Stopping and disabling Print Spooler service..."

Stop-Service -Name "Spooler" -Force -ErrorAction SilentlyContinue
Set-Service -Name "Spooler" -StartupType Disabled

# ---------------------
# 3. Install Software with Chocolatey
# ---------------------
Write-Output "Installing Chocolatey and tools (Notepad++, 7-Zip, TeamViewer)..."

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Install Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Output "❌ Chocolatey installation failed. Exiting."
    exit 1
}

# Install apps
Start-Process choco -ArgumentList "install notepadplusplus -y" -Wait
Start-Process choco -ArgumentList "install 7zip -y" -Wait
Start-Process choco -ArgumentList "install teamviewer -y" -Wait

# ---------------------
# 4. Harden TLS/Cipher Settings
# ---------------------
Write-Output "Applying cipher and TLS settings..."

$regFile = @"
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server]
"Enabled"=dword:ffffffff
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128/128]
"Enabled"=dword:ffffffff
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256/256]
"Enabled"=dword:ffffffff
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA256]
"Enabled"=dword:ffffffff
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA384]
"Enabled"=dword:ffffffff
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA512]
"Enabled"=dword:ffffffff
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\ECDH]
"Enabled"=dword:ffffffff
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002]
"Functions"="TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
"@

$tempRegFile = "$env:TEMP\CiphersConfig.reg"
$regFile | Out-File -FilePath $tempRegFile -Encoding ASCII
Start-Process -FilePath "reg.exe" -ArgumentList "import `"$tempRegFile`"" -Wait
Remove-Item $tempRegFile -Force

Write-Output "✅ Script completed successfully."
