# 1. Install Chocolatey and Tools
# This script installs Chocolatey and some common tools (Notepad++, 7-Zip) using Chocolatey.
# It also sets the execution policy to Bypass for the current process and ensures TLS 1.2 is used for secure downloads.
Write-Output "Installing Chocolatey and tools (Notepad++, 7-Zip)..."

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Output " Chocolatey installation failed. Exiting."
    exit 1
}

Start-Process choco -ArgumentList "install notepadplusplus -y" -Wait
Start-Process choco -ArgumentList "install 7zip -y" -Wait