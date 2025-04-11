# ---------------------
# 1. Install Chocolatey and Tools
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


# ---------------------
# 2. Apply Cipher and TLS Hardening via Registry
# ---------------------
Write-Output "Applying cipher and TLS settings with Set-ItemProperty..."

$registrySettings = @{
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128/128" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256/256" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA256" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA384" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA512" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\ECDH" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" = @{
        "Functions" = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
    }
}

foreach ($path in $registrySettings.Keys) {
    try {
        # Create the registry path unconditionally; -Force will create it if it does not exist
        New-Item -Path $path -Force | Out-Null

        foreach ($name in $registrySettings[$path].Keys) {
            $value = $registrySettings[$path][$name]

            # Determine the registry value type
            if ($value -is [string]) {
                Set-ItemProperty -Path $path -Name $name -Value $value -Type String
            } else {
                Set-ItemProperty -Path $path -Name $name -Value $value -Type DWord
            }
            Write-Output "✅ Set $name in $path"
        }
    }
    catch {
        Write-Error "❌ Failed to set properties for $path. Error details: $_"
    }
}

Write-Output "✅ Script completed successfully!"



