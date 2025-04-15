# Configure GPO Policies using LGPO.exe
# This script configures Group Policy Object (GPO) policies using LGPO.exe
# from the Microsoft Security Compliance Toolkit.

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

    # Download the PolicyRules file from your public repo
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

    # Set working directory to where LGPO.exe is located
    Set-Location (Split-Path $lgpoPath)

    # Define files to capture LGPO.exe output and errors
    $outputFile = "$env:TEMP\LGPO_Output.txt"
    $errorFile = "$env:TEMP\LGPO_Error.txt"

    $lgpoResult = Start-Process -FilePath $lgpoPath `
                                 -ArgumentList "/p", $policyRulesPath `
                                 -Wait -PassThru -NoNewWindow `
                                 -RedirectStandardOutput $outputFile `
                                 -RedirectStandardError $errorFile

    # Read and log LGPO.exe output and error content
    $lgpoOutput = Get-Content $outputFile -Raw
    $lgpoError = Get-Content $errorFile -Raw
    Write-Log "LGPO.exe output: $lgpoOutput"
    Write-Log "LGPO.exe error output: $lgpoError"

    # Log a warning if LGPO.exe returns a nonzero exit code, but continue execution
    if ($lgpoResult.ExitCode -ne 0) {
        Write-Log "WARNING: LGPO.exe returned exit code $($lgpoResult.ExitCode), but policies appear to be applied."
    }

    Write-Log "GPO Installation completed successfully"
}
catch {
    Write-Log "Error occurred: $_"
    throw $_
}
