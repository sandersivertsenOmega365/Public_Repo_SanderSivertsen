<#
Simple helper for non-technical users: converts a PDF to JPEG files.
- Installs ImageMagick + Ghostscript via winget if they are missing.
- Prompts for a PDF file if no path is provided.
- Puts the JPEG files in a "jpg" folder next to the PDF and opens that folder.
#>

[CmdletBinding()]
param(
    [string]$PdfPath,
    [string]$OutputFolder,
    [int]$Dpi = 300,
    [int]$Quality = 90
)

$ErrorActionPreference = 'Stop'

if ([System.Threading.Thread]::CurrentThread.ApartmentState -ne 'STA') {
    Write-Host "Starter pa nytt i STA-modus for filvalg-dialog..." -ForegroundColor Cyan
    $argsList = "-NoProfile -ExecutionPolicy Bypass -STA -File `"$PSCommandPath`""
    Start-Process -FilePath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList $argsList -Wait
    exit
}

function Write-Step([string]$text) {
    Write-Host $text -ForegroundColor Cyan
}

function Ensure-Winget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "Winget mangler. Installer winget (kjor Install-Winget.ps1 eller hent fra Microsoft Store) og prov igjen."
    }
}

function Update-WingetSources {
    try {
        Write-Step "Oppdaterer winget-kilder..."
        $proc = Start-Process -FilePath "winget" -ArgumentList @("source","update") -Wait -PassThru -NoNewWindow
    } catch {
        Write-Host "Klarte ikke a oppdatere winget-kilder, prover videre..." -ForegroundColor Yellow
    }
}

function Install-PackageIfMissing {
    param(
        [Parameter(Mandatory)][string]$CommandName,
        [Parameter(Mandatory)][string]$PackageId,
        [Parameter(Mandatory)][string]$FriendlyName
    )

    if (Get-Command $CommandName -ErrorAction SilentlyContinue) {
        return
    }

    Write-Step "Installerer $FriendlyName (kan ta litt tid, trenger nett og winget)..."
    $arguments = @(
        "install", "-e", "--id", $PackageId,
        "--accept-package-agreements", "--accept-source-agreements", "--silent"
    )
    $process = Start-Process -FilePath "winget" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -ne 0) {
        throw "Klarte ikke a installere $FriendlyName (feilkode $($process.ExitCode))."
    }
}

function Install-GhostscriptIfMissing {
    if (Get-Command gswin64c -ErrorAction SilentlyContinue) { return }

    Write-Step "Installerer Ghostscript (kan ta litt tid, trenger nett og winget)..."
    $candidateIds = @(
        "ArtifexSoftware.Ghostscript",
        "Ghostscript.Ghostscript"
    )
    foreach ($id in $candidateIds) {
        try {
            $arguments = @(
                "install", "-e", "--id", $id,
                "--accept-package-agreements", "--accept-source-agreements", "--silent"
            )
            $process = Start-Process -FilePath "winget" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
            if ($process.ExitCode -eq 0 -and (Get-Command gswin64c -ErrorAction SilentlyContinue)) {
                return
            }
        } catch {
            # try next id
        }
    }
    throw "Klarte ikke a installere Ghostscript via winget. Prov a oppdatere winget-kilder og installer manuelt (se README)."
}

function Pick-Pdf {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = "PDF files (*.pdf)|*.pdf"
    $dialog.Multiselect = $false
    $dialog.Title = "Velg PDF som skal gjores om til bilder"
    $result = $dialog.ShowDialog()
    if ($result -ne [System.Windows.Forms.DialogResult]::OK -or [string]::IsNullOrWhiteSpace($dialog.FileName)) {
        throw "Ingen PDF valgt."
    }
    return $dialog.FileName
}

try {
    Write-Step "Sjekker forutsetninger..."
    Ensure-Winget
    Update-WingetSources
    Install-PackageIfMissing -CommandName "magick" -PackageId "ImageMagick.ImageMagick" -FriendlyName "ImageMagick"
    Install-GhostscriptIfMissing
} catch {
    Write-Host $_ -ForegroundColor Red
    Write-Host "Avbryter. Fiks feilen over og prov igjen." -ForegroundColor Red
    exit 1
}

if (-not $PdfPath) {
    try {
        $PdfPath = Pick-Pdf
    } catch {
        Write-Host $_ -ForegroundColor Red
        exit 1
    }
}

if (-not (Test-Path $PdfPath)) {
    Write-Host "Finner ikke PDF: $PdfPath" -ForegroundColor Red
    exit 1
}

$pdfDirectory = Split-Path $PdfPath
$pdfName = [IO.Path]::GetFileNameWithoutExtension($PdfPath)

if (-not $OutputFolder) {
    $OutputFolder = Join-Path $pdfDirectory "jpg"
}

if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

Write-Step "Konverterer PDF -> JPEG (DPI=$Dpi, kvalitet=$Quality)..."
$outputPattern = Join-Path $OutputFolder "$pdfName-side-%03d.jpg"

try {
    & magick -density $Dpi -- $PdfPath -quality $Quality $outputPattern
    Write-Step "Ferdig! Bildene ligger i: $OutputFolder"
    Start-Process -FilePath "explorer.exe" -ArgumentList $OutputFolder
} catch {
    Write-Host "Noe feilet under konvertering: $_" -ForegroundColor Red
    exit 1
}
