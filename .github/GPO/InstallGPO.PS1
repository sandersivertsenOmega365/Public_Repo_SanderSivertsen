$toolsFolder = "C:\Tools\GPO"
New-Item -Path $toolsFolder -ItemType Directory -Force

# Download LGPO.exe
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Omega365/cloud-platform/master/code/PowerShell/LocalGPO/WindowsServer2022-CIS-L2/GPO/LGPO.exe" -OutFile "$toolsFolder\LGPO.exe"

# Download the Policy Rules file
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Omega365/cloud-platform/master/code/PowerShell/LocalGPO/WindowsServer2022-CIS-L2/GPO/WindowsServer2022-CIS-L2.PolicyRules" -OutFile "$toolsFolder\WindowsServer2022-CIS-L2.PolicyRules"

# Apply the GPO policies
Set-Location $toolsFolder
.\LGPO.exe /p .\WindowsServer2022-CIS-L2.PolicyRules

# Force group policy update
gpupdate /force