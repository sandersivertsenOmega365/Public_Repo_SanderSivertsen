$ErrorActionPreference = 'Stop'
$repo = 'c:\GIt\Public_Repo_SanderSivertsen'
$relDir = Join-Path $repo 'PDF-to-JPEG\releases'
if (!(Test-Path -LiteralPath $relDir)) { New-Item -ItemType Directory -Path $relDir | Out-Null }
$zip = Join-Path $relDir 'PDF-to-JPEG-v1.0.zip'
if (Test-Path -LiteralPath $zip) { Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Join-Path $repo 'PDF-to-JPEG\*') -DestinationPath $zip -Force
Write-Output "Created: $zip"