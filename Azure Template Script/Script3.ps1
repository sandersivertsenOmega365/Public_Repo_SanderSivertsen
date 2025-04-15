# Configure GPO Policies using LGPO.exe
# This script is used to configure Group Policy Object (GPO) policies using LGPO.exe from the Microsoft Security Compliance Toolkit.

Write-Output "Preparing to configure GPO policies..."

# Set error action preference to stop on all errors
$ErrorActionPreference = 'Stop'

# Configure logging
$logFile = "C:\GPOInstall.log"
function Write-Log {
    param($Message)
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
    Write-Output $logMessage
    Add-Content -Path $logFile -Value $logMessage
}

try {
    Write-Log "Starting GPO Installation process"

    # Create tools directory if it doesn't exist
    $toolsFolder = "C:\Tools\GPO"
    if (-not (Test-Path $toolsFolder)) {
        Write-Log "Creating tools folder at $toolsFolder"
        New-Item -Path $toolsFolder -ItemType Directory -Force
    }

    # Download and extract LGPO from Microsoft Security Compliance Toolkit
    $sctDownloadUrl = "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip"
    $lgpoZipPath = "$toolsFolder\LGPO.zip"

    if (-not (Get-ChildItem -Path $toolsFolder -Recurse -Filter "LGPO.exe")) {
        Write-Log "Downloading Microsoft Security Compliance Toolkit LGPO"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $maxRetries = 3
        $retryCount = 0
        $success = $false

        while (-not $success -and $retryCount -lt $maxRetries) {
            try {
                Write-Log "Attempting to download LGPO.zip (Attempt $($retryCount + 1))"
                Invoke-WebRequest -Uri $sctDownloadUrl -OutFile $lgpoZipPath

                Write-Log "Extracting LGPO.zip"
                Expand-Archive -Path $lgpoZipPath -DestinationPath $toolsFolder -Force
                Remove-Item $lgpoZipPath -Force

                $success = $true
            }
            catch {
                $retryCount++
                if ($retryCount -lt $maxRetries) {
                    Write-Log "Download/Extract failed. Retrying in 10 seconds..."
                    Start-Sleep -Seconds 10
                }
                else {
                    throw "Failed to download/extract LGPO after $maxRetries attempts: $_"
                }
            }
        }
    }

    # Dynamically locate LGPO.exe
    $lgpoPath = Get-ChildItem -Path $toolsFolder -Recurse -Filter "LGPO.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

    if (-not $lgpoPath -or -not (Test-Path $lgpoPath)) {
        throw "LGPO.exe not found under $toolsFolder"
    }

    # The PolicyRules file will be downloaded from your public repo
    $policyRulesUrl = "https://raw.githubusercontent.com/sandersivertsenOmega365/Public_Repo_SanderSivertsen/refs/heads/main/.github/GPO/WindowsServer2022-CIS-L2.PolicyRules"
    $policyRulesPath = "$toolsFolder\WindowsServer2022-CIS-L2.PolicyRules"
    Write-Log "Downloading PolicyRules file"

    $maxRetries = 3
    $retryCount = 0
    $success = $false

    while (-not $success -and $retryCount -lt $maxRetries) {
        try {
            Write-Log "Attempting to download PolicyRules file (Attempt $($retryCount + 1))"
            Invoke-WebRequest -Uri $policyRulesUrl -OutFile $policyRulesPath
            $success = $true
        }
        catch {
            $retryCount++
            if ($retryCount -lt $maxRetries) {
                Write-Log "Download failed. Retrying in 10 seconds..."
                Start-Sleep -Seconds 10
            }
            else {
                throw "Failed to download PolicyRules file after $maxRetries attempts"
            }
        }
    }

    if (-not (Test-Path $policyRulesPath)) {
        throw "PolicyRules file not found at $policyRulesPath"
    }

    # Apply GPO policies
    Write-Log "Applying GPO policies"
    Set-Location (Split-Path $lgpoPath)
    $lgpoResult = Start-Process -FilePath $lgpoPath -ArgumentList "/p", $policyRulesPath -Wait -PassThru -NoNewWindow
    if ($lgpoResult.ExitCode -ne 0) {
        throw "LGPO.exe failed with exit code $($lgpoResult.ExitCode)"
    }

    # Force group policy update
    Write-Log "Updating Group Policy"
    $gpResult = Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -Wait -PassThru -NoNewWindow
    if ($gpResult.ExitCode -ne 0) {
        throw "GPUpdate failed with exit code $($gpResult.ExitCode)"
    }

    Write-Log "GPO Installation completed successfully"
}
catch {
    Write-Log "Error occurred: $_"
    throw $_
}
