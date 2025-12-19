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

function Write-Step([string]$text) {
    Write-Host $text -ForegroundColor Cyan
}

function Ensure-Winget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "Winget mangler. Installer winget (kjor Install-Winget.ps1 eller hent fra Microsoft Store) og prov igjen."
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
    Install-PackageIfMissing -CommandName "magick" -PackageId "ImageMagick.ImageMagick" -FriendlyName "ImageMagick"
    Install-PackageIfMissing -CommandName "gswin64c" -PackageId "ArtifexSoftware.GhostScript" -FriendlyName "Ghostscript"
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
