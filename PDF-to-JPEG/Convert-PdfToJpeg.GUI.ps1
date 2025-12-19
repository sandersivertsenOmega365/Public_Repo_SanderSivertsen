<#
Simple Windows GUI for PDF -> JPEG conversion (non-technical friendly)
- Two fields: Pick PDF and choose output folder
- Optional DPI and Quality
- Ensures ImageMagick + Ghostscript are installed (winget or GitHub fallback)
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

if ([System.Threading.Thread]::CurrentThread.ApartmentState -ne 'STA') {
    $argsList = "-NoProfile -ExecutionPolicy Bypass -STA -File `"$PSCommandPath`""
    Start-Process -FilePath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList $argsList -Wait
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Write-Step([string]$text) { Write-Host $text -ForegroundColor Cyan }
function Ensure-Winget { if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw "Winget mangler. Installer App Installer fra Microsoft Store og prov igjen." } }
function Update-WingetSources { try { Start-Process -FilePath "winget" -ArgumentList @("source","update") -Wait -PassThru -NoNewWindow | Out-Null } catch { } }
function Ensure-Tls12 { try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { } }

function Install-PackageIfMissing {
    param(
        [Parameter(Mandatory)][string]$CommandName,
        [Parameter(Mandatory)][string]$PackageId,
        [Parameter(Mandatory)][string]$FriendlyName
    )
    if (Get-Command $CommandName -ErrorAction SilentlyContinue) { return }
    Write-Step "Installerer $FriendlyName..."
    $arguments = @("install","-e","--id",$PackageId,"--accept-package-agreements","--accept-source-agreements","--silent")
    $process = Start-Process -FilePath "winget" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -ne 0) { throw "Klarte ikke a installere $FriendlyName (kode $($process.ExitCode))." }
}

function Install-GhostscriptIfMissing {
    if (Get-Command gswin64c -ErrorAction SilentlyContinue) { return }
    Write-Step "Installerer Ghostscript..."
    $candidateIds = @("ArtifexSoftware.Ghostscript","Ghostscript.Ghostscript")
    foreach ($id in $candidateIds) {
        try {
            $arguments = @("install","-e","--id",$id,"--accept-package-agreements","--accept-source-agreements","--silent")
            $process = Start-Process -FilePath "winget" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
            if ($process.ExitCode -eq 0 -and (Get-Command gswin64c -ErrorAction SilentlyContinue)) { return }
        } catch { }
    }
    Write-Step "Finner ikke via winget, prover GitHub..."
    Install-GhostscriptFromGithubLatest
    if (Get-Command gswin64c -ErrorAction SilentlyContinue) { return }
    throw "Klarte ikke a installere Ghostscript automatisk. Installer manuelt (se README)."
}

function Install-GhostscriptFromGithubLatest {
    Ensure-Tls12
    $headers = @{ "User-Agent" = "PowerShell" }
    $apiUrl = "https://api.github.com/repos/ArtifexSoftware/ghostpdl-downloads/releases/latest"
    try {
        $release = Invoke-RestMethod -Uri $apiUrl -Headers $headers -UseBasicParsing -ErrorAction Stop
        $asset = $release.assets | Where-Object { $_.name -match "w64\.exe$" } | Select-Object -First 1
        if (-not $asset) { throw "Fant ikke Windows 64-bit installer i siste release." }
        $downloadUrl = $asset.browser_download_url
        $tempExe = Join-Path $env:TEMP $asset.name
        Write-Step "Laster ned: $($asset.name) ..."
        Invoke-WebRequest -Uri $downloadUrl -Headers $headers -OutFile $tempExe -UseBasicParsing -ErrorAction Stop
        Write-Step "Starter Ghostscript-installasjon..."
        Start-Process -FilePath $tempExe -Wait
    } catch {
        Write-Host "GitHub-nedlasting feilet: $_" -ForegroundColor Yellow
    }
}

function Ensure-GhostscriptPath {
    if (Get-Command gswin64c -ErrorAction SilentlyContinue) { return }
    $base = "C:\Program Files\gs"
    if (Test-Path $base) {
        Get-ChildItem -Path $base -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $bin = Join-Path $_.FullName "bin"
            $exe = Join-Path $bin "gswin64c.exe"
            if (Test-Path $exe) { [Environment]::SetEnvironmentVariable("PATH","$env:PATH;${bin}","Process") }
        }
    }
}

function Convert-PdfToJpeg([string]$PdfPath,[string]$OutputFolder,[int]$Dpi,[int]$Quality) {
    if (-not (Test-Path $PdfPath)) { throw "Finner ikke PDF: $PdfPath" }
    if (-not (Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }
    $pdfName = [IO.Path]::GetFileNameWithoutExtension($PdfPath)
    $pdfFull = (Resolve-Path -LiteralPath $PdfPath).Path
    $outFull = (Resolve-Path -LiteralPath $OutputFolder).Path
    $outputPattern = Join-Path $outFull "$pdfName-side-%03d.jpg"
    $pdfArg = $pdfFull -replace '\\','/'
    $outArg = $outputPattern -replace '\\','/'
    $args = @('-density', $Dpi, '--', $pdfArg, '-quality', $Quality, $outArg)
    & magick @args
}

# Ensure prerequisites upfront
try {
    Write-Step "Sjekker forutsetninger..."
    Ensure-Winget
    Update-WingetSources
    Install-PackageIfMissing -CommandName "magick" -PackageId "ImageMagick.ImageMagick" -FriendlyName "ImageMagick"
    Install-GhostscriptIfMissing
    Ensure-GhostscriptPath
} catch {
    [System.Windows.Forms.MessageBox]::Show("Kan ikke starte: " + $_, "PDF til JPEG", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
}

# Build UI
$form = New-Object System.Windows.Forms.Form
$form.Text = "PDF til JPEG"
$form.StartPosition = "CenterScreen"
$form.Size = New-Object System.Drawing.Size(560, 230)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

$labelPdf = New-Object System.Windows.Forms.Label
$labelPdf.Text = "PDF-fil"
$labelPdf.Location = New-Object System.Drawing.Point(15, 20)
$labelPdf.Size = New-Object System.Drawing.Size(60, 20)

$textPdf = New-Object System.Windows.Forms.TextBox
$textPdf.Location = New-Object System.Drawing.Point(85, 18)
$textPdf.Size = New-Object System.Drawing.Size(360, 20)

$btnPdf = New-Object System.Windows.Forms.Button
$btnPdf.Text = "Bla gjennom..."
$btnPdf.Location = New-Object System.Drawing.Point(455, 16)
$btnPdf.Size = New-Object System.Drawing.Size(85, 24)

$labelOut = New-Object System.Windows.Forms.Label
$labelOut.Text = "Lagre til"
$labelOut.Location = New-Object System.Drawing.Point(15, 60)
$labelOut.Size = New-Object System.Drawing.Size(60, 20)

$textOut = New-Object System.Windows.Forms.TextBox
$textOut.Location = New-Object System.Drawing.Point(85, 58)
$textOut.Size = New-Object System.Drawing.Size(360, 20)

$btnOut = New-Object System.Windows.Forms.Button
$btnOut.Text = "Velg mappe..."
$btnOut.Location = New-Object System.Drawing.Point(455, 56)
$btnOut.Size = New-Object System.Drawing.Size(85, 24)

$labelDpi = New-Object System.Windows.Forms.Label
$labelDpi.Text = "DPI"
$labelDpi.Location = New-Object System.Drawing.Point(85, 95)
$labelDpi.Size = New-Object System.Drawing.Size(40, 20)

$numDpi = New-Object System.Windows.Forms.NumericUpDown
$numDpi.Location = New-Object System.Drawing.Point(130, 93)
$numDpi.Size = New-Object System.Drawing.Size(70, 20)
$numDpi.Minimum = 72
$numDpi.Maximum = 600
$numDpi.Value = 300

$labelQuality = New-Object System.Windows.Forms.Label
$labelQuality.Text = "Kvalitet"
$labelQuality.Location = New-Object System.Drawing.Point(220, 95)
$labelQuality.Size = New-Object System.Drawing.Size(55, 20)

$numQuality = New-Object System.Windows.Forms.NumericUpDown
$numQuality.Location = New-Object System.Drawing.Point(280, 93)
$numQuality.Size = New-Object System.Drawing.Size(70, 20)
$numQuality.Minimum = 50
$numQuality.Maximum = 100
$numQuality.Value = 90

$btnConvert = New-Object System.Windows.Forms.Button
$btnConvert.Text = "Gjor om til bilder"
$btnConvert.Location = New-Object System.Drawing.Point(85, 130)
$btnConvert.Size = New-Object System.Drawing.Size(160, 30)

$status = New-Object System.Windows.Forms.Label
$status.Text = ""
$status.Location = New-Object System.Drawing.Point(85, 170)
$status.Size = New-Object System.Drawing.Size(360, 20)
$status.ForeColor = [System.Drawing.Color]::DarkGreen

$btnPdf.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Filter = "PDF files (*.pdf)|*.pdf"
    $dlg.Multiselect = $false
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textPdf.Text = $dlg.FileName
        $dir = Split-Path $dlg.FileName
        $pdfName = [IO.Path]::GetFileNameWithoutExtension($dlg.FileName)
        $textOut.Text = Join-Path $dir "jpg"
    }
})

$btnOut.Add_Click({
    $folderDlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDlg.Description = "Velg mappe for bilder"
    if ($folderDlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { $textOut.Text = $folderDlg.SelectedPath }
})

$btnConvert.Add_Click({
    try {
        $pdf = $textPdf.Text
        $out = $textOut.Text
        $dpi = [int]$numDpi.Value
        $qual = [int]$numQuality.Value
        if ([string]::IsNullOrWhiteSpace($pdf)) { throw "Velg en PDF-fil." }
        if ([string]::IsNullOrWhiteSpace($out)) { throw "Velg en mappe for lagring." }
        $status.Text = "Konverterer..."
        Convert-PdfToJpeg -PdfPath $pdf -OutputFolder $out -Dpi $dpi -Quality $qual
        $status.Text = "Ferdig! Aapner mappe..."
        Start-Process -FilePath "explorer.exe" -ArgumentList $out
        $status.Text = "Ferdig"
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Feil under konvertering: " + $_, "PDF til JPEG", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    }
})

$form.Controls.AddRange(@($labelPdf,$textPdf,$btnPdf,$labelOut,$textOut,$btnOut,$labelDpi,$numDpi,$labelQuality,$numQuality,$btnConvert,$status))
[void]$form.ShowDialog()
