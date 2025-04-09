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
New-NetFirewallRule -DisplayName "$ruleName - TCP" `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort $port

# UDP Rule
New-NetFirewallRule -DisplayName "$ruleName - UDP" `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol UDP `
                    -LocalPort $port

# ---------------------
# 2. Stop and Disable Print Spooler Service
# ---------------------
Write-Output "Stopping and disabling Print Spooler service..."

Stop-Service -Name "Spooler" -Force
Set-Service -Name "Spooler" -StartupType Disabled

# ---------------------
# 3. Install Software with Chocolatey
# ---------------------
Write-Output "Installing Chocolatey and tools (Notepad++, 7-Zip, TeamViewer)..."

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Install Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install apps
choco install notepadplusplus -y
choco install 7zip -y
choco install teamviewer -y

Write-Output "Setup complete!"
