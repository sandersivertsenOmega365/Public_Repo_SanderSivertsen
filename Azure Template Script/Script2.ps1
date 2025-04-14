# ---------------------
# 2. Apply Cipher and TLS Hardening via Registry
# ---------------------
$logFile = "C:\Windows\Temp\SecurityHardening_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
function Write-Log {
    param($Message)
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
    Write-Output $logMessage
    Add-Content -Path $logFile -Value $logMessage
}

Write-Log "Starting security hardening process..."

# Backup current settings
$backupFile = "C:\Windows\Temp\SecuritySettings_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
Write-Log "Creating registry backup to $backupFile"
reg export "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL" $backupFile /y

$registrySettings = @{
    # Disable older TLS versions
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" = @{
        "Enabled" = 0x00000000
        "DisabledByDefault" = 0x00000001
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" = @{
        "Enabled" = 0x00000000
        "DisabledByDefault" = 0x00000001
    }
    # Enable TLS 1.2 and 1.3
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" = @{
        "Enabled" = 0xFFFFFFFF
        "DisabledByDefault" = 0x00000000
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Server" = @{
        "Enabled" = 0xFFFFFFFF
        "DisabledByDefault" = 0x00000000
    }
    # Configure Ciphers
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128/128" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256/256" = @{
        "Enabled" = 0xFFFFFFFF
    }
    # Configure Hashes
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA256" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA384" = @{
        "Enabled" = 0xFFFFFFFF
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA512" = @{
        "Enabled" = 0xFFFFFFFF
    }
    # Configure Key Exchange Algorithms
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\ECDH" = @{
        "Enabled" = 0xFFFFFFFF
    }
    # Configure Cipher Suite Order
    "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" = @{
        "Functions" = "TLS_AES_256_GCM_SHA384,TLS_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
    }
}

$error = $false
foreach ($path in $registrySettings.Keys) {
    try {
        Write-Log "Configuring $path"
        New-Item -Path $path -Force | Out-Null

        foreach ($name in $registrySettings[$path].Keys) {
            $value = $registrySettings[$path][$name]

            # Set the registry value
            if ($value -is [string]) {
                Set-ItemProperty -Path $path -Name $name -Value $value -Type String
            } else {
                Set-ItemProperty -Path $path -Name $name -Value $value -Type DWord
            }

            # Verify the change
            $verifyValue = Get-ItemProperty -Path $path -Name $name -ErrorAction Stop
            if ($verifyValue.$name -eq $value) {
                Write-Log "Successfully set $name = $value in $path"
            } else {
                Write-Log "WARNING: Value verification failed for $name in $path"
                $error = $true
            }
        }
    }
    catch {
        Write-Log "ERROR: Failed to set properties for $path. Error details: $_"
        $error = $true
    }
}

# Final status check
if ($error) {
    Write-Log "Script completed with errors. Please check the log file at $logFile"
    exit 1
} else {
    Write-Log "Security hardening completed successfully!"
    Write-Log "Backup file created at: $backupFile"
    Write-Log "Log file location: $logFile"
}