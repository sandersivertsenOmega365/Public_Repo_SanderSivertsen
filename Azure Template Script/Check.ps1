<#
.SYNOPSIS
    Verifies that Chocolatey, installed tools, and registry settings have been applied.

.DESCRIPTION
    This script checks:
      1. Chocolatey installation.
      2. Installation of Notepad++, 7-Zip, and optionally TeamViewer.
      3. Registry settings for cipher and TLS hardening.
    It outputs a pass/fail message for each check and provides an overall verification summary.
    
.NOTES
    - Run this script with administrative privileges.
    - Adjust file paths if your environment differs.
.EXAMPLE
    .\Verify-Changes.ps1
#>

# ---------------------
# 1. Verify Chocolatey and Tools Installation
# ---------------------
Write-Output "---------------------------"
Write-Output "Verifying Installation of Tools"
Write-Output "---------------------------"

$allChecksPassed = $true

# Verify Chocolatey installation
if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
    Write-Output "✅ Chocolatey is installed."
} else {
    Write-Error "❌ Chocolatey is NOT installed."
    $allChecksPassed = $false
}

# Verify Notepad++ installation (chocolatey shims are usually placed in C:\ProgramData\chocolatey\bin)
$notepadPlusPlusPath = "C:\ProgramData\chocolatey\bin\notepad++.exe"
if (Test-Path $notepadPlusPlusPath) {
    Write-Output "✅ Notepad++ is installed."
} else {
    Write-Error "❌ Notepad++ is NOT installed at $notepadPlusPlusPath."
    $allChecksPassed = $false
}

# Verify 7-Zip installation (common default location)
$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"
if (Test-Path $sevenZipPath) {
    Write-Output "✅ 7-Zip is installed."
} else {
    Write-Error "❌ 7-Zip is NOT installed at $sevenZipPath."
    $allChecksPassed = $false
}

# Optionally, verify TeamViewer installation (adjust paths as needed)
$teamViewerPath = "C:\Program Files (x86)\TeamViewer\TeamViewer.exe"
if (Test-Path $teamViewerPath) {
    Write-Output "✅ TeamViewer is installed."
} else {
    Write-Output "ℹ️ TeamViewer not found at $teamViewerPath. (If TeamViewer installation was desired, please verify.)"
}


# ---------------------
# 2. Verify Registry Settings for Cipher and TLS Hardening
# ---------------------
Write-Output ""
Write-Output "--------------------------------------------"
Write-Output "Verifying Registry Settings for Cipher/TLS Hardening"
Write-Output "--------------------------------------------"

# Define the expected registry settings (same as applied earlier)
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

foreach ($regPath in $registrySettings.Keys) {
    Write-Output "`nChecking registry key: $regPath"
    
    if (-not (Test-Path $regPath)) {
        Write-Error "❌ Registry key not found: $regPath"
        $allChecksPassed = $false
        continue
    }

    foreach ($prop in $registrySettings[$regPath].Keys) {
        $expectedValue = $registrySettings[$regPath][$prop]
        try {
            $actualValue = (Get-ItemProperty -Path $regPath -Name $prop -ErrorAction Stop).$prop
            
            # If the expected value is numeric, convert it to decimal for comparison.
            if ($expectedValue -is [int] -or $expectedValue -is [uint32]) {
                # 0xFFFFFFFF equals 4294967295 in decimal
                if ([UInt32]$actualValue -eq [UInt32]$expectedValue) {
                    Write-Output "✅ [$regPath] '$prop' matches expected value: $expectedValue"
                } else {
                    Write-Error "❌ [$regPath] '$prop': Expected '$expectedValue' but got '$actualValue'"
                    $allChecksPassed = $false
                }
            }
            else {
                if ($actualValue -eq $expectedValue) {
                    Write-Output "✅ [$regPath] '$prop' matches expected value: $expectedValue"
                } else {
                    Write-Error "❌ [$regPath] '$prop': Expected '$expectedValue' but got '$actualValue'"
                    $allChecksPassed = $false
                }
            }
        }
        catch {
            Write-Error "❌ Unable to retrieve property '$prop' from $regPath. Error details: $_"
            $allChecksPassed = $false
        }
    }
}

# ---------------------
# Overall Summary
# ---------------------
Write-Output ""
if ($allChecksPassed) {
    Write-Output "🎉 All checks passed! The installation and configuration appear to be complete."
} else {
    Write-Error "⚠️ Some checks failed. Please review the above error messages and ensure all changes have been applied."
}
