# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Notepad++
choco install notepadplusplus -y

# Install 7-Zip
choco install 7zip -y
# Install TeamViewer
choco install teamviewer
