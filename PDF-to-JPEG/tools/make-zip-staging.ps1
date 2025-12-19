$ErrorActionPreference = 'Stop'
$repo = 'c:\GIt\Public_Repo_SanderSivertsen'
$src = Join-Path $repo 'PDF-to-JPEG'
$relDir = Join-Path $src 'releases'
if (!(Test-Path -LiteralPath $relDir)) { New-Item -ItemType Directory -Path $relDir | Out-Null }
$staging = Join-Path $relDir 'staging'
$zip = Join-Path $relDir 'PDF-to-JPEG-v1.0.zip'

# Clean previous artifacts
if (Test-Path -LiteralPath $zip) { Remove-Item -LiteralPath $zip -Force }
if (Test-Path -LiteralPath $staging) { Remove-Item -LiteralPath $staging -Recurse -Force }
New-Item -ItemType Directory -Path $staging | Out-Null

# Copy files excluding releases folder and *.log using Robocopy for reliability
$null = Start-Process -FilePath 'robocopy' -ArgumentList @("$src","$staging","/E","/XD","$relDir","/XF","*.log") -NoNewWindow -Wait -PassThru

# Create ZIP from staging
Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $zip -Force
Write-Output "Created: $zip"

# Clean staging folder
Remove-Item -LiteralPath $staging -Recurse -Force