@echo off
setlocal
REM Super-simple launcher for non-technical users
REM Runs Windows PowerShell in STA mode, captures output to a log, and pauses so errors are visible.

set SCRIPT=%~dp0Convert-PdfToJpeg.ps1
set LOG=%~dp0last-run.log

if not exist "%SCRIPT%" (
	echo Could not find Convert-PdfToJpeg.ps1 next to this file.
	echo Make sure you extracted the ZIP and kept files together.
	pause
	exit /b 1
)

echo Launching PDF to JPEG converter...
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -STA -File "%SCRIPT%" > "%LOG%" 2>&1
set ERR=%ERRORLEVEL%

if not %ERR%==0 (
	echo Something went wrong. Details below:
	echo ------------------------------------------------------------
	type "%LOG%"
	echo ------------------------------------------------------------
	echo Tips:
	echo - If you see 'winget' missing, install 'App Installer' from Microsoft Store.
	echo - If SmartScreen warns, click 'More info' then 'Run anyway'.
	echo - You can also right-click Convert-PdfToJpeg.ps1 and select 'Run with PowerShell'.
)

echo Press any key to close this window.
pause
endlocal
