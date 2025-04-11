# ================================
# Setup Script for Azure Image
# ================================

# ---------------------
# 1. Create Firewall Rule (TCP & UDP on port 55231)
# ---------------------
$ruleName = "Sander_Test"
$port = 55231

Write-Output "Creating firewall rules for TCP and UDP on port $port..."

if (-not (Get-NetFirewallRule -DisplayName "$ruleName - TCP" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -DisplayName "$ruleName - TCP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $port
}
if (-not (Get-NetFirewallRule -DisplayName "$ruleName - UDP" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -DisplayName "$ruleName - UDP" -Direction Inbound -Action Allow -Protocol UDP -LocalPort $port
}

# ---------------------
# 2. Stop and Disable Print Spooler Service
# ---------------------
Write-Output "Stopping and disabling Print Spooler service..."

Stop-Service -Name "Spooler" -Force -ErrorAction SilentlyContinue
Set-Service -Name "Spooler" -StartupType Disabled

# ---------------------
# 3. Install Chocolatey and Tools
# ---------------------
Write-Output "Installing Chocolatey and tools (Notepad++, 7-Zip, TeamViewer)..."

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Output "❌ Chocolatey installation failed. Exiting."
    exit 1
}

Start-Process choco -ArgumentList "install notepadplusplus -y" -Wait
Start-Process choco -ArgumentList "install 7zip -y" -Wait
Start-Process choco -ArgumentList "install googlechrome -y" -Wait

# ---------------------
# 4. Apply Cipher and TLS Hardening via Registry
# ---------------------
Write-Output "Applying cipher and TLS settings with Set-ItemProperty..."

$registrySettings = @{
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" = @{ "Enabled" = 0xFFFFFFFF }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128/128" = @{ "Enabled" = 0xFFFFFFFF }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256/256" = @{ "Enabled" = 0xFFFFFFFF }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA256" = @{ "Enabled" = 0xFFFFFFFF }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA384" = @{ "Enabled" = 0xFFFFFFFF }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA512" = @{ "Enabled" = 0xFFFFFFFF }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\ECDH" = @{ "Enabled" = 0xFFFFFFFF }
    "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" = @{
        "Functions" = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
    }
}

foreach ($path in $registrySettings.Keys) {
    if (-not (Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }

    foreach ($name in $registrySettings[$path].Keys) {
        $value = $registrySettings[$path][$name]
        if ($value -is [string]) {
            Set-ItemProperty -Path $path -Name $name -Value $value -Type String
        } else {
            Set-ItemProperty -Path $path -Name $name -Value $value -Type DWord
        }
        Write-Output "✅ Set $name in $path"
    }
}

Write-Output "✅ Script completed successfully!"
